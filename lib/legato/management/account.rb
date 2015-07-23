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
      attr_writer :web_properties

      def initialize(attributes, user)
        self.user = user

        self.id = attributes['id'] || attributes[:id]
        self.name = attributes['name'] || attributes[:name]
      end

      def web_properties
        @web_properties ||= WebProperty.for_account(self)
      end

      def profiles
        @web_properties ?
          @web_properties.map { |property| property.profiles }.flatten :
          Profile.for_account(self)
      end

      def self.from_child(child)
        all(child.user).detect {|a| a.id == child.account_id}
      end

      def self.build_from_summary(attributes, user)
        properties = attributes['webProperties'] || attributes[:webProperties]

        Account.new(attributes, user).tap { |account|
          account.web_properties = properties.map { |property|
            property['accountId'] = account.id
            WebProperty.build_from_summary(property, user, account)
          }
        }
      end
    end
  end
end
