module Legato
  class PaginatedQuery < Query

    attr_accessor :total_limit

    def each(&block)
      loop do
        super
        break unless next_iteration
      end
    end

    def next_iteration
      @offset += limit
      @limit = calucate_limit
      if limit > 0
        @loaded = false
        self
      else
        nil
      end
    end

    def apply_basic_options(options)
      @total_limit = options[:total_limit]
      query_opts = options.dup
      query_opts[:limit] = query_opts.delete :request_limit
      query_opts[:offset] = 1
      super(query_opts)
    end

    private


    def calucate_limit
      max_left = (total_limit || totals_for_all_results) - offset + 1
      max_left < limit ? max_left : limit
    end
  end
end