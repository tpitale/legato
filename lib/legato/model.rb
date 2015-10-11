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
      @metrics ||= ListParameter.new(:metrics, [])
      @metrics << fields
    end

    # Adds dimensions to the class for retrieval from GA
    #
    # @param *fields [Symbol] the names of the fields to retrieve
    # @return [ListParameter] the set of all dimensions
    def dimensions(*fields)
      @dimensions ||= ListParameter.new(:dimensions, [])
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
      add_method_to_set(name, :filters, &block)
    end

    def segments
      @segments ||= {}
    end
    alias :segment_filters :segments

    # Define a segment
    #
    # @param name [Symbol] the class method name for the resulting segment
    # @param block the block which contains filter methods to define the
    #   parameters used for segmenting the request to GA
    # @return [Proc] the body of newly defined method
    def segment(name, &block)
      add_method_to_set(name, :segment_filters, &block)
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
    #   * segment_id
    # @return [Query] a new query with all the filters/segments defined on the
    #   model, allowing for chainable behavior before kicking of the request
    #   to Google Analytics which returns the result data
    def results(profile, options = {})
      # TODO: making tracking scope configurable when results are querried.  not sure how to do this.
      Query.new(self).apply_options(options.merge(:profile => profile))
    end

    # Builds a `query` and sets the `realtime` property
    #
    # @return [Query] a new query with `realtime` property set
    def realtime
      Query.new(self).realtime
    end

    def add_method_to_set(name, type, &block)
      send(type)[name] = block

      (class << self; self; end).instance_eval do
        define_method(name) {|*args| Query.new(self).apply_filter_expression(type, *args, &block)}
      end
    end
  end
end
