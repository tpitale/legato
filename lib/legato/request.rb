module Legato
  class Request
    attr_reader :user, :query

    def initialize(user, query)
      @user = user
      @query = query
    end

    def response(url = nil)
      Legato::Response.new(raw_response, query.instance_klass)
    end

    def raw_response
      api_key? ? oauth_1_response : oauth_2_response
    end

    def api_key?
      !user.api_key.nil?
    end

    private
    def oauth_2_response
      # oauth 2
      get(query.base_url, :params => query.to_params)
    end

    def oauth_1_response
      # oauth 1 + api key
      get(query.base_url + query_string)
    end

    def get(*args)
      user.access_token.get(*args)
    end

    def query_string
      # may need to add !~@
      [api_key_string, URI.escape(query.to_query_string, '<>')].compact.join('&')
    end

    def api_key_string
      "?key=#{user.api_key}"
    end
  end
end
