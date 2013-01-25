require "bundler/gem_tasks"
require 'rspec/core/rake_task'

require 'oauth'
require 'oauth2'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# get oauth2 via device code, unimplemented as of now
# curl -d "client_id={{client_id}}&scope=https://www.googleapis.com/auth/analytics.readonly" https://accounts.google.com/o/oauth2/device/code
# { "device_code" : "4/8O1xUKWzOdJESG7ednnulZPsbyNt", "user_code" : "3tywhirg", "verification_url" : "http://www.google.com/device", "expires_in" : 1800, "interval" : 5 }
# curl -d "client_id={{client_id}}&client_secret={{client_secret}}&code=4/8O1xUKWzOdJESG7ednnulZPsbyNt&grant_type=http://oauth.net/grant_type/device/1.0" https://accounts.google.com/o/oauth2/token
# { "access_token" : "ERspXATXoblahblahblah", "token_type" : "Bearer", "expires_in" : 3600, "refresh_token" : "1/balhaajsdfklasfdjs;df" }

module OAuth2Helpers
  def build_client(id, secret)
    # This is my test client account for Legato.
    opts = {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'
    }

    OAuth2::Client.new(id, secret, opts)
  end

  def auth_url(client)
    client.auth_code.authorize_url({
      :scope => 'https://www.googleapis.com/auth/analytics.readonly',
      :redirect_uri => 'http://localhost'
    })
  end

  extend self
end

namespace :oauth2 do
  desc "Get a new OAuth2 Token"
  task :token do
    puts 'Get your OAuth2 id and secret from the API Console: https://code.google.com/apis/console#access'

    puts
    print 'Your OAuth2 id: '
    oauth_id = $stdin.gets.strip
    print 'Your OAuth2 secret: '
    oauth_secret = $stdin.gets.strip

    client = OAuth2Helpers.build_client(oauth_id, oauth_secret)

    puts
    puts "Opening the OAuth2 auth url: #{OAuth2Helpers.auth_url(client)} ..."
    `open "#{OAuth2Helpers.auth_url(client)}"`

    puts
    print 'OAuth2 Code (in the url): '
    code = $stdin.gets.strip

    access_token = client.auth_code.get_token(code, :redirect_uri => 'http://localhost')

    puts
    puts "Here's your access token: "
    puts access_token.token
  end
end

# namespace :oauth do
#   def consumer(id, secret)
#     OAuth::Consumer.new('779170787975.apps.googleusercontent.com', 'mbCISoZiSwyVQIDEbLj4EeEc', {
#       :site => "https://www.google.com",
#       :request_token_path => "/accounts/OAuthGetRequestToken",
#       :access_token_path => "/accounts/OAuthGetAccessToken",
#       :authorize_path => "/accounts/OAuthAuthorizeToken"
#     })
#   end

#   def request_token
#     @request_token ||= consumer.get_request_token({}, {:scope => "https://www.googleapis.com/auth/analytics.readonly"})
#   end

#   def auth_url
#     request_token.authorize_url
#   end

#   def access_token
#     @access_token ||= begin
#       print 'OAuth Code: '
#       code = $stdin.gets.strip
#       request_token.get_access_token(:oauth_verifier => code)
#     end
#   end

#   desc "Get a new OAuth Token"
#   task :token do
#     `open "#{auth_url}"`

#     puts "Token: #{access_token.token}"
#     puts "Secret: #{access_token.secret}"
#   end
# end
