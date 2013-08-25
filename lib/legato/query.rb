module Legato
  class Query
    include Enumerable

    MONTH = 2592000
    REQUEST_FIELDS = 'columnHeaders/name,rows,totalResults,totalsForAllResults'

    def define_filter(name, &block)
      (class << self; self; end).instance_eval do
        define_method(name) {|*args| apply_filter(*args, &block)}
      end
    end

    def define_segment_filter(name, &block)
      (class << self; self; end).instance_eval do
        define_method(name) {|*args| apply_segment_filter(*args, &block)}
      end
    end

    def self.define_filter_operators(*methods)
      methods.each do |method|
        class_eval <<-CODE
          def #{method}(field, value, join_character=nil)
            Filter.new(field, :#{method}, value, join_character)
          end
        CODE
      end
    end

    attr_reader :parent_klass
    attr_accessor :profile, :start_date, :end_date
    attr_accessor :sort, :limit, :offset, :quota_user #, :segment # individual, overwritten
    attr_accessor :filters, :segment_filters # combined, can be appended to

    def initialize(klass)
      @loaded = false
      @parent_klass = klass
      self.filters = FilterSet.new
      self.segment_filters = FilterSet.new
      self.start_date = Time.now - MONTH
      self.end_date = Time.now

      klass.filters.each do |name, block|
        define_filter(name, &block)
      end

      klass.segments.each do |name, block|
        define_segment_filter(name, &block)
      end
    end

    def instance_klass
      @parent_klass.instance_klass
    end

    def apply_filter(*args, &block)
      apply_filter_expression(self.filters, *args, &block)
    end

    def apply_segment_filter(*args, &block)
      apply_filter_expression(self.segment_filters, *args, &block)
    end

    def apply_filter_expression(filter_set, *args, &block)
      @profile = extract_profile(args)

      join_character = Legato.and_join_character # filters are joined by AND

      # # block returns one filter or an array of filters
      Array.wrap(instance_exec(*args, &block)).each do |filter|
        filter.join_character ||= join_character # only set when not set explicitly
        filter_set << filter

        join_character = Legato.or_join_character # arrays are joined by OR
      end
      self
    end

    def apply_options(options)
      if options.has_key?(:sort)
        # warn
        options[:sort] = options.delete(:sort)
      end

      apply_basic_options(options)
      # apply_filter_options(options[:filters])

      self
    end

    def apply_basic_options(options)
      [:sort, :limit, :offset, :start_date, :end_date, :quota_user].each do |key| #:segment
        self.send("#{key}=".to_sym, options[key]) if options.has_key?(key)
      end
    end

    # def apply_filter_options(filter_options)
    #   join_character = Legato.and_join_character
    #
    #   Array.wrap(filter_options).compact.each do |filter|
    #     filter.each do |key, value|
    #       self.filters << hash_to_filter(key, value, join_character)
    #       join_character = Legato.and_join_character # hashes are joined by AND
    #     end
    #     join_character = Legato.or_join_character # arrays are joined by OR
    #   end
    # end

    # def hash_to_filter(key, value, join_character)
    #   field, operator = key, :eql
    #   field, operator = key.target, key.operator if key.is_a?(SymbolOperatorMethods)

    #   Filter.new(field, operator, value, join_character)
    # end

    def extract_profile(args)
      return args.shift if args.first.is_a?(Management::Profile)
      return args.pop if args.last.is_a?(Management::Profile)
      profile
    end

    define_filter_operators :eql, :not_eql, :gt, :gte, :lt, :lte, :matches,
      :does_not_match, :contains, :does_not_contain, :substring, :not_substring

    def loaded?
      @loaded
    end

    def load
      response = request_for_query
      @collection = response.collection
      @total_results = response.total_results
      @totals_for_all_results = response.totals_for_all_results
      @loaded = true
    end

    def collection
      load unless loaded?
      @collection
    end
    alias :to_a :collection

    def total_results
      load unless loaded?
      @total_results
    end

    def totals_for_all_results
      load unless loaded?
      @totals_for_all_results
    end

    def each(&block)
      collection.each(&block)
    end

    # if no filters, we use results to add profile
    def results(profile=nil, options={})
      options, profile = profile, nil if profile.is_a?(Hash)

      self.profile = profile unless profile.nil?
      apply_options(options)
      self
    end

    # def total_results
    #   collection.total_results
    # end

    # def sampled?
    #   collection.sampled?
    # end

    def metrics
      @metrics ||= parent_klass.metrics.dup
    end

    def dimensions
      @dimensions ||= parent_klass.dimensions.dup
    end

    def sort=(arr)
      @sort = Legato::ListParameter.new(:sort, arr)
    end

    def segment
      "dynamic::#{segment_filters.to_params}" if segment_filters.any?
    end

    # def segment_id
    #   segment.nil? ? nil : "gaid::#{segment}"
    # end

    def profile_id
      profile && Legato.to_ga_string(profile.id)
    end

    def to_params
      params = {
        'ids' => profile_id,
        'start-date' => Legato.format_time(start_date),
        'end-date' => Legato.format_time(end_date),
        'max-results' => limit,
        'start-index' => offset,
        'segment' => segment,
        'filters' => filters.to_params, # defaults to AND filtering
        'fields' => REQUEST_FIELDS,
        'quotaUser' => quota_user
      }

      [metrics, dimensions, sort].each do |list|
        params.merge!(list.to_params) unless list.nil?
      end

      params.reject {|k,v| v.nil? || v.to_s.strip.length == 0}
    end

    def to_query_string
      list = to_params.map {|k,v| [k,v].join("=")}
      "?#{list.join("&")}"
    end

    private
    def request_for_query
      profile.user.request(self)
    end
  end
end
