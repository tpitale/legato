module Legato
  class ListParameter

    attr_reader :name, :elements

    def initialize(name, elements=[])
      @name = name
      @elements = Array.wrap(elements)
    end

    def name
      @name.to_s
    end

    def <<(element)
      (@elements += Array.wrap(element)).compact!
      self
    end

    def to_params
      value = elements.map{|element| Legato.to_ga_string(element)}.join(',')
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
