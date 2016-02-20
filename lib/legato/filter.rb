module Legato
  class Filter
    attr_accessor :field, :operator, :value, :join_character

    OPERATORS = {
      # metrics
      :eql => '==',
      :not_eql => '!=',
      :gt => '>',
      :gte => '>=',
      :lt => '<',
      :lte => '<=',
      # dimensions
      :matches => '==',
      :does_not_match => '!=',
      :substring => '=@',
      :not_substring => '!@',
      :contains => '=~', # regex
      :does_not_contain => '!~' # regex
      # :desc => '-',
      # :descending => '-'
    }

    def initialize(query, field, operator, value, join_character)
      @query = query

      self.field = field
      self.operator = operator
      self.value = value
      self.join_character = join_character # if nil, will be overridden by Query#apply_filter
    end

    def tracking_scope
      @query.tracking_scope
    end

    def google_field
      Legato.to_ga_string(field, tracking_scope)
    end

    def google_operator
      OPERATORS[operator]
    end

    # escape comma and semicolon in value to differentiate
    # from those used as join characters for OR/AND
    def escaped_value
      # backslash is escaped in strings
      # oauth will cgi/uri escape for us
      value.to_s.gsub(/([,;])/) {|c| '\\'+c}
    end

    def to_param
      [google_field, google_operator, escaped_value].join
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
