module Legato::Core::V4
  class Request
    attr_reader :user, :query

    def initialize(user, query)
      @user = user
      @query = query
    end

    def response(url = nil)
      Legato::Core::V4::Response.new(raw_response, query.instance_klass)
    end

    def raw_response
      # oauth 2
      post(base_url, :body => query.to_body)
    end

    # def api_key?
    #   !user.api_key.nil?
    # end

    private
    # def oauth_2_response
    # end

    # def oauth_1_response
    #   # oauth 1 + api key
    #   post(base_url + query_string)
    # end

    def base_url
      "https://analyticsreporting.googleapis.com/v4/reports:batchGet"
    end

    def post(*args)
      user.access_token.post(*args)
    end

    # def query_string
    #   # may need to add !~@
    #   [api_key_string, URI.escape(query.to_query_string, '<>')].compact.join('&')
    # end

    # def api_key_string
    #   "?key=#{user.api_key}"
    # end
  end
end
