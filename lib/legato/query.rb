module Legato
  class Query
    include Enumerable

    MONTH = 2592000

    def define_filter(name, block)
      (class << self; self; end).instance_eval do
        define_method(name) {|*args| apply_filter(*args, block)}
      end
    end

    def self.define_filter_operators(*methods)
      methods.each do |method|
        class_eval <<-CODE
          def #{method}(field, value)
            Filter.new(field, :#{method}, value) # defaults to joining with AND
          end
        CODE
      end
    end

    attr_reader :parent_klass
    attr_accessor :profile, :start_date, :end_date
    attr_accessor :limit, :offset, :segment, :order # individual, overwritten
    attr_accessor :filters # appended to, may add :segments later for dynamic segments

    def initialize(klass)
      @loaded = false
      @parent_klass = klass
      self.filters = FilterSet.new
      self.start_date = Time.now - MONTH
      self.end_date = Time.now

      klass.filter_definitions.each do |name, block|
        define_filter(name, block)
      end

      # may add later for dynamic segments
      # klass.segment_definitions.each do |name, segment|
      #   self.class.define_segment(name, segment)
      # end
    end

    def apply_filter(*args, block)
      @profile = extract_profile(args)

      join_character = Legato.and_join_character # filters are joined by AND

      # block returns one filter or an array of filters
      Array.wrap(instance_exec(*args, &block)).each do |filter|
        filter.join_character = join_character
        self.filters << filter

        join_character = Legato.or_join_character # arrays are joined by OR
      end
      self
    end

    def apply_options(options)
      if options.has_key?(:sort)
        # warn
        options[:order] = options[:sort]
      end

      apply_basic_options(options)
      apply_filter_options(options[:filters])

      self
    end

    def apply_basic_options(options)
      [:start_date, :end_date, :order, :limit, :offset, :segment].each do |key|
        self.send("#{key}=".to_sym, options[key]) if options.has_key?(key)
      end
    end

    def apply_filter_options(filter_options)
      join_character = Legato.and_join_character

      Array.wrap(filter_options).compact.each do |filter|
        filter.each do |key, value|
          self.filters << hash_to_filter(key, value, join_character)
          join_character = Legato.and_join_character # hashes are joined by AND
        end
        join_character = Legato.or_join_character # arrays are joined by OR
      end
    end

    def hash_to_filter(key, value, join_character)
      field, operator = key, :eql
      field, operator = key.target, key.operator if key.is_a?(SymbolOperatorMethods)

      Filter.new(field, operator, value, join_character)
    end

    def order=(order)
      @order = ReportParameter.new(:order, order)
    end

    def extract_profile(args)
      return args.shift if args.first.is_a?(Management::Profile)
      return args.pop if args.last.is_a?(Management::Profile)
    end

    define_filter_operators :eql, :not_eql, :gt, :gte, :lt, :lte, :matches,
      :does_not_match, :contains, :does_not_contain, :substring, :not_substring

    def loaded?
      @loaded
    end

    def load
      @loaded = true
      @collection = ReportRequest.new(self).response.results
    end

    def collection
      load unless loaded?
      @collection
    end
    alias :to_a :collection

    def each(&block)
      collection.each(&block)
    end

    # backwards compatability
    def results(profile=nil, options={})
      self.profile = profile unless profile.nil?
      apply_options(options)
      self
    end

    def total_results
      collection.total_results
    end

    def sampled?
      collection.sampled?
    end

    def metrics
      parent_klass.metrics
    end

    def dimensions
      parent_klass.dimensions
    end

    def segment_id
      segment.nil? ? nil : "gaid::#{segment}"
    end

    def profile_id
      # should we raise here?
      profile.nil? ? nil : Legato.to_ga(profile.id)
    end

    def to_params
      params = {
        'ids' => profile_id,
        'start-date' => Legato.format_time(start_date),
        'end-date' => Legato.format_time(end_date),
        'max-results' => limit,
        'start-index' => offset,
        'segment' => segment_id,
        'filters' => filters.to_params # defaults to AND filtering
      }

      [metrics, dimensions, order].each do |report_parameter|
        params.merge!(report_parameter.to_params) unless report_parameter.nil?
      end

      params.reject {|k,v| v.nil? || v.to_s.strip.length == 0}
    end
  end
end
