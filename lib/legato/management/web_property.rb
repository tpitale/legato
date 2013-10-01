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

      attr_accessor :id, :name, :website_url, :account_id, :user, :attributes

      def initialize(attributes, user)
        self.user = user
        self.id = attributes['id']
        self.name = attributes.delete('name')
        self.website_url = attributes.delete('websiteUrl')
        self.account_id = attributes.delete('accountId')
        self.attributes = attributes
      end

      def self.for_account(account)
        all(account.user, account.path+'/webproperties')
      end
    end
  end
end
