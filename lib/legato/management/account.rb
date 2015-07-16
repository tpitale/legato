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

      def initialize(attributes, user, web_properties=nil)
        self.user = user

        self.id = attributes['id'] || attributes[:id]
        self.name = attributes['name'] || attributes[:name]
        @web_properties = web_properties
      end

      def web_properties
        @web_properties ||= WebProperty.for_account(self)
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
        web_properties_attributes = attributes['webProperties'] || attributes[:webProperties]

        summary_properties = web_properties_attributes.inject([]) { |props, web_property_attributes|
          web_property_attributes['accountId'] = attributes['id'] || attributes[:id]
          props << WebProperty.build_from_summary(web_property_attributes, user)
        }

        Account.new(attributes, user, summary_properties)
      end
    end
  end
end
