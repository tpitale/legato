module Legato
  class ListParameter

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
      value = elements.map{|el| Legato.to_ga_string(el, tracking_scope)}.join(',')
      value.empty? ? {} : {name => value}
    end

    # TODO: test
    def to_hash(tracking_scope)
      empty? ? {} : {
        name => elements.map {|el| {element_key => Legato.to_ga_string(el, tracking_scope)}}
      }
    end

    def ==(other)
      name == other.name && elements == other.elements
    end

    def include?(element)
      @elements.include?(element)
    end

    def empty?
      @elements.empty?
    end

    def element_key
      case @name
      when :metrics
        :expression
      when :dimensions
        :name
      end
    end
  end
end
