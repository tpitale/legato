module Legato
  module Management
    class Query
      attr_reader :instance_klass, :base_url

      attr_accessor :quota_user, :user_ip

      def initialize(base_url, instance_klass)
        @base_url = base_url
        @instance_klass = instance_klass
      end

      def to_params
        {
          'quotaUser' => quota_user,
          'userIp' => user_ip
        }.reject {|_,v| v.nil?}
      end

      def to_query_string
        to_params.map {|k,v| [k,v].join("=")}.join("&")
      end
    end
  end
end
