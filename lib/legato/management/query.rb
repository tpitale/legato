module Legato
  module Management
    class Query
      attr_reader :instance_klass, :base_url

      def initialize(base_url, instance_klass)
        @base_url = base_url
        @instance_klass = instance_klass
      end

      def to_params
        {}
      end

      def to_query_string
        nil
      end
    end
  end
end
