module Legato
  class ListParameter

    attr_reader :name

    FORMATTERS = {
      metrics: Legato::RequestFormatters::Metric,
      dimensions: Legato::RequestFormatters::Dimension,
      sort: Legato::RequestFormatters::Sort
    }

    def initialize(name, elements=[])
      @name = name
      @elements = Set.new Array.wrap(elements).compact
    end

    def name
      @name.to_s
    end

    def <<(element)
      @elements += Array.wrap(element).compact
      self
    end

    def elements
      @elements.to_a
    end

    def to_params(tracking_scope)
      value = elements.map{|element| Legato.to_ga_string(element, tracking_scope)}.join(',')
      value.empty? ? {} : {name => value}
    end

    def to_report_format
      elements.map{|element| formatter.to_report_format(element)}
    end

    def formatter
      @formatter ||= FORMATTERS[@name].new
    end

    def ==(other)
      name == other.name && elements == other.elements
    end

    def include?(element)
      @elements.include?(element)
    end
  end
end
