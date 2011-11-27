module Legato
  class FilterSet
    include Enumerable

    def initialize
      @filters = []
    end

    def each(&block)
      @filters.each(&block)
    end

    def to_a
      @filters
    end

    def <<(filter)
      @filters << filter
    end

    def to_params
      @filters.inject(nil) do |params, filter|
        filter.join_with(params)
      end
    end
  end
end
