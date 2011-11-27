module Legato
  class Filter
    attr_accessor :field, :operator, :value, :join_character

    OPERATORS = {
      :eql => '==',
      :not_eql => '!=',
      :gt => '>',
      :gte => '>=',
      :lt => '<',
      :lte => '<=',
      :matches => '==',
      :does_not_match => '!=',
      :contains => '=~',
      :does_not_contain => '!~',
      :substring => '=@',
      :not_substring => '!@',
      :desc => '-',
      :descending => '-'
    }

    def initialize(field, operator, value, join_character='%3B')
      self.field = field
      self.operator = operator
      self.value = value
      self.join_character = join_character
    end

    def google_field
      Legato.to_ga(field)
    end

    def google_operator
      URI.encode(OPERATORS[operator], /[=<>]/)
    end

    def escaped_value
      CGI::escape(value.to_s.gsub(/([,;\\])/) {|c| '\\'+c})
    end

    def to_param
      "#{google_field}#{google_operator}#{escaped_value}"
    end

    def join_with(param)
      param << join_character unless param.nil?
      param.nil? ? to_param : (param << to_param)
    end

    def ==(other)
      field == other.field &&
      operator == other.operator &&
      value == other.value &&
      join_character == other.join_character
    end
  end
end
