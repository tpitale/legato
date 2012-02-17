# module Legato
#   class Request
#     URL = "https://www.googleapis.com/analytics/v3/data/ga"
# 
#     def initialize(query)
#       @query = query
#     end
# 
#     def response
#       @response ||= Response.new(parsed_response)
#     end
# 
#     def parsed_response
#       MultiJson.decode(raw_response)
#     end
# 
#     def raw_response
#       @query.profile.user.get(URL, :params => @query.to_params)
#     end
#   end
# end
