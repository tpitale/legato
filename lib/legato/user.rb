module Legato
  class User
    attr_accessor :access_token, :api_key

    def initialize(token, api_key = nil)
      self.access_token = token
      self.api_key = api_key
    end

    URL = "https://www.googleapis.com/analytics/v3/data/ga"

    def request(query)
      begin
        raw_response = if api_key
          # oauth 1 + api key
          access_token.get(URL + query.to_query_string + "&key=#{api_key}")
        else
          # oauth 2
          access_token.get(URL, :params => query.to_params)
        end

        Response.new(raw_response)
      rescue => e
        p e.code
        raise e
      end
    end

    # Management
    def accounts
      Management::Account.all(self)
    end

    def web_properties
      Management::WebProperty.all(self)
    end

    def profiles
      Management::Profile.all(self)
    end

  end
end
