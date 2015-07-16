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
        all(account.user, account.path+'/webproperties')
      end

      def profiles
        @profiles ||= Profile.for_web_property(self)
      end

      def profiles=(value)
        @profiles = value
      end

      def account
        @account ||= Account.from_child(self)
      end

      def account=(value)
        @account = value
        @account_id = value.id
      end

      def self.from_child(child)
        path = new({:id => child.web_property_id, :account_id => child.account_id}, nil).path

        get(child.user, path)
      end

      def self.build_from_summary(attributes, user, account)
        profiles = attributes['profiles'] || attributes[:profiles]
        attributes.delete('profiles')
        web_property = WebProperty.new(attributes, user)

        summary_profiles = profiles.inject([]) { |summary_profiles, profile|
          summary_profiles << Profile.build_from_summary(profile, user, account, web_property)
        }

        web_property.account = account
        web_property.profiles = summary_profiles
        web_property
      end
    end
  end
end
