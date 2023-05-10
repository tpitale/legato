module Legato::Core::V4
  class Response
    def initialize(raw_response, instance_klass = OpenStruct)
      @raw_response = raw_response
      @instance_klass = instance_klass
    end

    def raw
      @raw ||= MultiJson.decode(@raw_response.body)
    end

    def collection
      raw_attributes.map {|attributes| @instance_klass.new(attributes)}
    end

    # def total_results
    #   data["totalResults"]
    # end

    # def totals_for_all_results
    #   Hash[data["totalsForAllResults"].map{|k,v| [Legato.from_ga_string(k), number_for(v)]}]
    # end

    # https://developers.google.com/analytics/devguides/reporting/core/v4/migration#sampled_data
    def sampled?
      data.has_key?("samplesReadCounts") && data.has_key?("samplingSpaceSizes")
    end

    # def items
    #   Array.wrap(data['items']).compact
    # end

    # private
    def headers
      raw['columnHeader']
    end

    def data
      raw['data']
    end

    def dimension_fields
      Array.wrap(headers['dimensions']).map {|dimension| Legato.from_ga_string(dimension)}
    end

    # The header entry also contains a "type", we're not doing anything with that yet
    def metric_fields
      data.fetch('metricHeader', {}).fetch('metricHeaderEntries', []).map {|entry| Legato.from_ga_string(entry['name'])}
    end

    def rows
      Array.wrap(data['rows']).compact
    end

    def raw_attributes
      # keep the order dimensions, and then metrics
      # each row will be read the same way
      fields = dimension_fields.concat(metric_fields)

      rows.map {|row| ReportRow.new(row, fields).to_h}
    end

    # def next_page_token
    #   raw['nextPageToken']
    # end

    # def number_for(str)
    #   return str.to_f if str.index('.')
    #   str.to_i
    # end
  end
end