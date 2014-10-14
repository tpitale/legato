module Legato
  module Management
    class Profile

      extend Finder
      include ProfileMethods

      def self.default_path
        "/accounts/~all/webproperties/~all/profiles"
      end

      def path
        "/accounts/#{account_id}/webproperties/#{web_property_id}/profiles/#{id}"
      end

      GA_ATTRIBUTES = {
        :id => 'id',
        :name => 'name',
        :account_id => 'accountId',
        :web_property_id => 'webPropertyId'
      }

      attr_accessor *GA_ATTRIBUTES.keys
      attr_accessor :user, :attributes

      def initialize(attributes, user)
        self.user = user

        GA_ATTRIBUTES.each do |key,string_key|
          self.send("#{key}=", attributes.delete(string_key) || attributes.delete(key))
        end

        self.attributes = attributes
      end

      def self.for_account(account)
        all(account.user, account.path+'/webproperties/~all/profiles')
      end

      def self.for_web_property(web_property)
        all(web_property.user, web_property.path+'/profiles')
      end

      def account
        @account ||= Account.from_child(self)
      end

      def web_property
        @web_property ||= WebProperty.from_child(self)
      end

      def goals
        Goal.for_profile(self)
      end
    end
  end
end
