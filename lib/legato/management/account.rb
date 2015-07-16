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

        self.id = attributes['id'] || attributes[:id]
        self.name = attributes['name'] || attributes[:name]
      end

      def web_properties
        @web_properties ||= WebProperty.for_account(self)
      end

      def web_properties=(value)
        @web_properties = value
      end

      def profiles
        if @web_properties
          @web_properties.inject([]) { |profiles, prop| profiles.concat(prop.profiles) }
        else
          Profile.for_account(self)
        end
      end

      def self.from_child(child)
        all(child.user).detect {|a| a.id == child.account_id}
      end

      def self.build_from_summary(attributes, user)
        properties = attributes['webProperties'] || attributes[:webProperties]
        account = Account.new(attributes, user)

        props = properties.inject([]) { |props, property| props << WebProperty.build_from_summary(property, user, account) }

        account.web_properties = props
        account
      end
    end
  end
end
