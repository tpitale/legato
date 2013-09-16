module Legato
  class User
    attr_accessor :access_token, :api_key, :tracking_scope

    VALID_TRACKING_SCOPES = ['ga', 'mcf']

    def initialize(token, api_key = nil, tracking_scope = "ga")
      raise "invalid tracking_scope" unless tracking_scope_valid?(tracking_scope)
      self.tracking_scope = tracking_scope
      self.access_token = token
      self.api_key = api_key
    end

    def request(query)
      raw_response = if api_key
        # oauth 1 + api key
        query_string = URI.escape(query.to_query_string, '<>') # may need to add !~@

        access_token.get(url + query_string + "&key=#{api_key}")
      else
        # oauth 2
        access_token.get(url, :params => query.to_params)
      end

      Response.new(raw_response, query.instance_klass)
    end

    # Management Associations

    # All the `Account` records available to this user
    def accounts
      Management::Account.all(self)
    end

    # All the `WebProperty` records available to this user
    def web_properties
      Management::WebProperty.all(self)
    end

    # All the `Profile` records available to this user
    def profiles
      Management::Profile.all(self)
    end

    private

    def url
      "https://www.googleapis.com/analytics/v3/data/#{tracking_scope}"
    end

    def tracking_scope_valid?(tracking_scope)
      VALID_TRACKING_SCOPES.include?(tracking_scope)
    end
  end
end
