module Legato
  class Response
    def initialize(raw_response, instance_klass = OpenStruct)
      @raw_response = raw_response
      @instance_klass = instance_klass
    end

    def data
      @data ||= MultiJson.decode(@raw_response.body)
    end

    def collection
      raw_attributes.map {|attributes| @instance_klass.new(attributes)}
    end

    def total_results
      data["totalResults"]
    end

    def totals_for_all_results
      Hash[data["totalsForAllResults"].map{|k,v| [Legato.from_ga_string(k), number_for(v)]}]
    end

    def rows
      Array.wrap(data['rows']).compact
    end

    def items
      Array.wrap(data['items']).compact
    end

    private
    def headers
      data['columnHeaders']
    end

    def fields
      headers.map {|header| Legato.from_ga_string(header['name'])}
    end

    def raw_attributes
      rows.map {|row| Hash[fields.zip(row)]}
    end

    def number_for(str)
      return str.to_f if str.index('.')
      str.to_i
    end
  end
end