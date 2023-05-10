require_relative 'v3/request'
require_relative 'v4/request'

module Legato::Core
  class Request
    def self.[](version)
      case version
      when 3
        V3::Request
      when 4
        V4::Request
      end
    end
  end
end
