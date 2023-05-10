# TODO: to/from report_format? Handle response formatter?
module Legato::RequestFormatters
  class Metric
    def to_report_format(element)
      {
        expression: Legato.to_ga_string(element)
      }
    end
  end
end
