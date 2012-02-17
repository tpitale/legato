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

    private
    def headers
      data['columnHeaders']
    end

    def fields
      headers.map {|header| Legato.from_ga_string(header['name'])}
    end

    def rows
      Array.wrap(data['rows']).compact
    end

    def raw_attributes
      rows.map {|row| Hash[fields.zip(row)]}
    end
  end
end