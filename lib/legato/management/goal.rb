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

      GA_ATTRIBUTES = {
        :id => 'id',
        :name => 'name',
        :account_id => 'accountId',
        :web_property_id => 'webPropertyId',
        :profile_id => 'profileId'
      }

      include Model

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
