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

      attr_accessor :id, :name, :web_property_id, :account_id, :user, :attributes

      def initialize(attributes, user)
        self.user = user
        self.id = attributes['id']
        self.name = attributes['name']
        self.account_id = attributes['accountId']
        self.web_property_id = attributes['webPropertyId']

        ['id', 'name', 'accountId', 'webPropertyId'].each { |key| attributes.delete(key) }
        self.attributes = attributes
      end

      def self.for_account(account)
        all(account.user, account.path+'/webproperties/~all/profiles')
      end

      def self.for_web_property(web_property)
        all(web_property.user, web_property.path+'/profiles')
      end

      def goals
        Goal.for_profile(self)
      end

      def filters
        Filter.for_profile(self)
      end
    end
  end
end
