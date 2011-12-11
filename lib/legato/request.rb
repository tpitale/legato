module Legato
  class Request
    URL = "https://www.googleapis.com/analytics/v3/data/ga"

    def initialize(query)
      @query = query
    end

    def response
      @response ||= @query.profile.user.get(URL, :params => @query.to_params)
    end

    def parsed_response
      JSON.parse(response)
    end
  end
end
