module Legato
  module Model
    def self.extended(base)
      ProfileMethods.add_profile_method(base)
    end

    # Adds metrics to the class for retrieval from GA
    #
    # @param *fields [Symbol] the names of the fields to retrieve
    # @return [ListParameter] the set of all metrics
    def metrics(*fields)
      fields, options = options_from_fields(fields)
      @metrics ||= ListParameter.new(:metrics, [], options.fetch(:tracking_scope, "ga"))
      @metrics << fields
    end

    # Adds dimensions to the class for retrieval from GA
    #
    # @param *fields [Symbol] the names of the fields to retrieve
    # @return [ListParameter] the set of all dimensions
    def dimensions(*fields)
      fields, options = options_from_fields(fields)
      @dimensions ||= ListParameter.new(:dimensions, [], options.fetch(:tracking_scope, "ga"))
      @dimensions << fields
    end

    def filters
      @filters ||= {}
    end

    # Define a filter
    #
    # @param name [Symbol] the class method name for the resulting filter
    # @param block the block which contains filter methods to define the
    #   parameters used for filtering the request to GA
    # @return [Proc] the body of newly defined method
    def filter(name, &block)
      filters[name] = block

      (class << self; self; end).instance_eval do
        define_method(name) {|*args| Query.new(self).apply_filter(*args, &block)}
      end
    end

    def segments
      @segments ||= {}
    end

    # Define a segment
    #
    # @param name [Symbol] the class method name for the resulting segment
    # @param block the block which contains filter methods to define the
    #   parameters used for segmenting the request to GA
    # @return [Proc] the body of newly defined method
    def segment(name, &block)
      segments[name] = block

      (class << self; self; end).instance_eval do
        define_method(name) {|*args| Query.new(self).apply_segment_filter(*args, &block)}
      end
    end

    # Set the class used to make new instances of returned results from GA
    # 
    # @param klass [Class] any class that accepts a hash of attributes to
    #   initialize the values of the class
    # @return the original class given
    def set_instance_klass(klass)
      @instance_klass = klass
    end

    def instance_klass
      @instance_klass || OpenStruct
    end

    # Builds a `query` to get results from GA
    # 
    # @param profile [Legato::Management::Profile] the profile to query GA against
    # @param options [Hash] options:
    #   * start_date
    #   * end_date
    #   * limit
    #   * offset
    #   * sort
    #   * quota_user
    # @return [Query] a new query with all the filters/segments defined on the
    #   model, allowing for chainable behavior before kicking of the request
    #   to Google Analytics which returns the result data
    def results(profile, options = {})
      # TODO: making tracking scope configurable when results are querried.  not sure how to do this.
      Query.new(self).results(profile, options)
    end

    # Builds a `query` and sets the `realtime` property
    # 
    # @return [Query] a new query with `realtime` property set
    def realtime
      Query.new(self).realtime
    end

    def options_from_fields(fields)
      options = fields.pop if fields.last.is_a?(Hash)
      [fields, (options || {})]
    end

  end
end
