module Legato::Core::V3
  class Request
    attr_reader :user, :query

    def initialize(user, query)
      @user = user
      @query = query
    end

    def response(url = nil)
      Legato::Core::V3::Response.new(raw_response, query.instance_klass)
    end

    def raw_response
      api_key? ? oauth_1_response : oauth_2_response
    end

    def api_key?
      !user.api_key.nil?
    end

    def base_url
      # Handle management API queries
      return query.base_url if query.respond_to?(:base_url)

      raise "invalid tracking_scope" unless query.tracking_scope_valid?

      "https://www.googleapis.com/analytics/v3/data/#{query.tracking_scope}"
    end

    private
    def oauth_2_response
      # oauth 2
      get(base_url, :params => query.to_params)
    end

    def oauth_1_response
      # oauth 1 + api key
      get(base_url + query_string)
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
