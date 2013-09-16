module Legato
  module Model
    def self.extended(base)
      ProfileMethods.add_profile_method(base)
    end

    def metrics(*fields)
      fields, options = options_from_fields(fields)
      @metrics ||= ListParameter.new(:metrics, [], options.fetch(:tracking_scope, "ga"))
      @metrics << fields
    end

    def dimensions(*fields)
      fields, options = options_from_fields(fields)
      @dimensions ||= ListParameter.new(:dimensions, [], options.fetch(:tracking_scope, "ga"))
      @dimensions << fields
    end

    def filters
      @filters ||= {}
    end

    def filter(name, &block)
      filters[name] = block

      (class << self; self; end).instance_eval do
        define_method(name) {|*args| Query.new(self).apply_filter(*args, &block)}
      end
    end

    def segments
      @segments ||= {}
    end

    def segment(name, &block)
      segments[name] = block

      (class << self; self; end).instance_eval do
        define_method(name) {|*args| Query.new(self).apply_segment_filter(*args, &block)}
      end
    end

    def set_instance_klass(klass)
      @instance_klass = klass
    end

    def instance_klass
      @instance_klass || OpenStruct
    end

    def results(profile, options = {})
      # TODO: making tracking scope configurable when results are querried.  not sure how to do this.
      Query.new(self).results(profile, options)
    end

    def options_from_fields(fields)
      options = options.pop if options.last.is_a?(Hash)
      if options
        fields = fields[0...-1]
      end
      fields, (options || {})
    end

  end
end
