module Legato
  module Management
    class Account
      extend Finder

      def self.default_path
        "/accounts"
      end

      def path
        "/accounts/#{id}"
      end

      attr_accessor :id, :name, :user

      def initialize(attributes, user)
        self.user = user
        self.id = attributes['id']
        self.name = attributes['name']
      end
    end
  end
end
