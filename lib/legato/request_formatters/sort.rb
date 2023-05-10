module Legato::RequestFormatters
  class Sort
    def to_report_format(element)
      {
        fieldName: Legato.to_ga_string(name_only(element)),
        sortOrder: order(element)
      }.reject{|_,v| v.nil?}
    end

    private
    # if we left the - on the name, it would
    # remain after to_ga_string
    def name_only(element)
      # substitute only the first -
      element.gsub(/^-/, '')
    end

    def order(element)
      element.start_with?('-') ? 'DESCENDING' : nil
    end
  end
end
