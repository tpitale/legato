module Legato
  module Management
    class Goal

      extend Finder

      def self.default_path
        "/accounts/~all/webproperties/~all/profiles/~all/goals"
      end

      def path
        self.class.default_path + "/" + id.to_s
      end

      attr_accessor :id, :name, :account_id, :web_property_id, :profile_id, :user, :attributes

      def initialize(attributes, user)
        self.user = user
        self.id = attributes['id']
        self.name = attributes['name']
        self.account_id = attributes['accountId']
        self.web_property_id = attributes['webPropertyId']
        self.profile_id = attributes['profileId']

        ['id', 'name', 'accountId', 'webPropertyId', 'profileId'].each { |key| attributes.delete(key) }
        self.attributes = attributes
      end

      def self.for_account(account)
        all(account.user, account.path+'/webproperties/~all/profiles/~all/goals')
      end

      def self.for_web_property(web_property)
        all(web_property.user, web_property.path+'/profiles/~all/goals')
      end

      def self.for_profile(profile)
        all(profile.user, profile.path+'/goals')
      end
    end
  end
end
