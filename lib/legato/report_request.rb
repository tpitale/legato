module Legato
  class ReportRequest
    URL = "https://www.google.com/analytics/feeds/data"

    # takes a query containing the profile, the limit/offset/sort, the filters, the segments, and a model
    # the model contains metrics/dimensions
    # Make a data request, pass that to ReportResponse and return it

    def initialize(query)
      @query = query
      @request = Request::Data.new(@query.profile.session, URL, @query.to_params)
    end

    def response
      @response ||= begin
        ReportResponse.new(@request.send_request.body, @query.parent_klass.instance_klass)
      end
    end
  end
end
