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

      attr_accessor :id, :name, :user,:attributes

      def initialize(attributes, user)
        self.user = user
        self.id = attributes['id']
        self.name = attributes['name']
        ['id', 'name'].each { |key| attributes.delete(key) }
        self.attributes = attributes
      end

      def web_properties
        WebProperty.for_account(self)
      end

      def profiles
        Profile.for_account(self)
      end
    end
  end
end
