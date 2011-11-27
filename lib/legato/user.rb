module Legato
  class User
    attr_accessor :access_token

    def initialize(token)
      self.access_token = token
    end
  end
end