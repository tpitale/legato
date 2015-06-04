module Legato
  class ListParameter

    attr_reader :name

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

    def ==(other)
      name == other.name && elements == other.elements
    end

    def include?(element)
      @elements.include?(element)
    end
  end
end
