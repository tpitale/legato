require_relative 'v3/response'
require_relative 'v4/response'

module Legato::Core
  class Response
    def self.[](version)
      case version
      when 3
        V3::Response
      when 4
        V4::Response
      end
    end
  end
end
