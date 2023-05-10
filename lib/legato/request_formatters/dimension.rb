module Legato::RequestFormatters
  class Dimension
    def to_report_format(element)
      {
        name: Legato.to_ga_string(element)
      }
    end
  end
end
