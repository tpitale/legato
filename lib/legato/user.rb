module Legato
  class User
    attr_accessor :access_token

    def initialize(token)
      self.access_token = token
    end

    URL = "https://www.googleapis.com/analytics/v3/data/ga"

    def request(query)
      begin
        Response.new(access_token.get(URL, :params => query.to_params))
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
