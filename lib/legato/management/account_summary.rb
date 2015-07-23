module Legato
  module Management
    class AccountSummary
      extend Finder

      def self.default_path
        "/accountSummaries"
      end

      def path
        ""
      end

      attr_accessor :user, :account

      def initialize(attributes, user)
        self.user = user

        @account = Account.build_from_summary(attributes, user)
      end

      def web_properties
        @account.web_properties
      end

      def profiles
        @account.profiles
      end

    end
  end
end
