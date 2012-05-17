require 'oauth2'

module Support
  module Macros
    module OAuth
      def token
        # fill me in if you add more tests here, use the rake task oauth:token, update vcr to :record => :all
        "ya29.AHES6ZREobGegWLc3tyxuuQAkKF7lg071UgpTeLe_4jTcV35uW8"
      end

      def client
        opts = {
          :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
          :token_url => 'https://accounts.google.com/o/oauth2/token'
        }

        OAuth2::Client.new('779170787975.apps.googleusercontent.com', 'mbCISoZiSwyVQIDEbLj4EeEc', opts) do |builder|
          builder.use VCR::Middleware::Faraday
          builder.adapter :net_http
        end
      end

      def access_token
        OAuth2::AccessToken.new(client, token)
      end
    end
  end
end
