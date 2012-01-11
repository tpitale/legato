module Legato
  class Response
    def initialize(raw_response, instance_klass = OpenStruct)
      @raw_response = raw_response
      @instance_klass = instance_klass
    end

    def data
      @data ||= JSON.parse(@raw_response.body)
    end

    def collection
      raw_attributes.map {|attributes| @instance_klass.new(attributes)}
    end

    private
    def headers
      data['columnHeaders']
    end

    def fields
      headers.map {|header| Legato.from_ga_string(header['name'])}
    end

    def rows
      data['rows']
    end

    def raw_attributes
      rows.map {|row| Hash[fields.zip(row)]}
    end
  end
end

# module Legato
#   class Response
#     KEYS = ['dxp$metric', 'dxp$dimension']
# 
#     # we could take the request, and be lazy about loading here, #refactoring
#     def initialize(response_body, instance_klass = OpenStruct)
#       @data = response_body
#       @instance_klass = instance_klass
#     end
# 
#     def results
#       if @results.nil?
#         @results = ResultSet.new(parse)
#         @results.total_results = parse_total_results
#         @results.sampled = parse_sampled_flag
#       end
# 
#       @results
#     end
# 
#     def sampled?
#     end
# 
#     private
#     def parse
#       entries.map do |entry|
#         @instance_klass.new(Hash[
#           values_for(entry).map {|v| [Garb.from_ga(v['name']), v['value']]}
#         ])
#       end
#     end
# 
#     def entries
#       feed? ? [parsed_data['feed']['entry']].flatten.compact : []
#     end
# 
#     def parse_total_results
#       feed? ? parsed_data['feed']['openSearch:totalResults'].to_i : 0
#     end
# 
#     def parse_sampled_flag
#       feed? ? (parsed_data['feed']['dxp$containsSampledData'] == 'true') : false
#     end
# 
#     def parsed_data
#       @parsed_data ||= JSON.parse(@data)
#     end
# 
#     def feed?
#       !parsed_data['feed'].nil?
#     end
# 
#     def values_for(entry)
#       KEYS.map {|k| entry[k]}.flatten.compact
#     end
#   end
# end
