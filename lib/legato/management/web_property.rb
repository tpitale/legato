module Legato
  module Management
    class WebProperty
      extend Finder

      def self.default_path
        "/accounts/~all/webproperties"
      end

      def path
        "/accounts/#{account_id}/webproperties/#{id}"
      end

      GA_ATTRIBUTES = {
        :id => 'id',
        :name => 'name',
        :account_id => 'accountId',
        :website_url => 'websiteUrl'
      }

      include Model

      attr_writer :account, :profiles

      def self.for_account(account)
        all(account.user, account.path+'/webproperties')
      end

      def profiles
        @profiles ||= Profile.for_web_property(self)
      end

      def account
        @account ||= Account.from_child(self)
      end

      def self.from_child(child)
        path = new({:id => child.web_property_id, :account_id => child.account_id}, nil).path

        get(child.user, path)
      end

      def self.build_from_summary(attributes, user, account)
        profiles = attributes.delete('profiles') || attributes.delete(:profiles)

        WebProperty.new(attributes, user).tap { |web_property|
          web_property.account = account
          web_property.profiles = profiles.map { |profile|
            profile['accountId'] = account.id
            profile['webPropertyId'] = web_property.id
            Profile.build_from_summary(profile, user, account, web_property)
          }
        }
      end
    end
  end
end
