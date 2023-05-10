module Legato::Core::V4
  class ReportRow
    def initialize(raw_row, fields)
      @dimensions = raw_row.fetch('dimensions', [])

      # TODO: handle an optional second date range?
      first_metric = raw_row.fetch('metrics', []).first || {}
      @metrics = first_metric.fetch('values', [])

      @fields = fields
    end

    def to_h
      Hash[@fields.zip(row)]
    end

    private
    def row
      @dimensions.concat(@metrics)
    end
  end
end
