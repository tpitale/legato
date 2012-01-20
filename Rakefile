require "bundler/gem_tasks"

require 'oauth'
require 'oauth2'

# get oauth2 via device code, unimplemented as of now
# curl -d "client_id={{client_id}}&scope=https://www.googleapis.com/auth/analytics.readonly" https://accounts.google.com/o/oauth2/device/code
# { "device_code" : "4/8O1xUKWzOdJESG7ednnulZPsbyNt", "user_code" : "3tywhirg", "verification_url" : "http://www.google.com/device", "expires_in" : 1800, "interval" : 5 }
# curl -d "client_id={{client_id}}&client_secret={{client_secret}}&code=4/8O1xUKWzOdJESG7ednnulZPsbyNt&grant_type=http://oauth.net/grant_type/device/1.0" https://accounts.google.com/o/oauth2/token
# { "access_token" : "ERspXATXoblahblahblah", "token_type" : "Bearer", "expires_in" : 3600, "refresh_token" : "1/balhaajsdfklasfdjs;df" }

namespace :oauth2 do
  def client
    # This is my test client account for Legato.
    OAuth2::Client.new('779170787975.apps.googleusercontent.com', 'mbCISoZiSwyVQIDEbLj4EeEc', {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'
    })
  end

  def auth_url
    client.auth_code.authorize_url({
      :scope => 'https://www.googleapis.com/auth/analytics.readonly',
      :redirect_uri => 'http://localhost'
    })
  end

  desc "Get a new OAuth2 Token"
  task :token do
    `open "#{auth_url}"`

    print 'OAuth2 Code: '
    code = $stdin.gets

    access_token = client.auth_code.get_token(code.strip, :redirect_uri => 'http://localhost')
    puts access_token.token
  end
end

namespace :oauth do
  def consumer
    OAuth::Consumer.new('779170787975.apps.googleusercontent.com', 'mbCISoZiSwyVQIDEbLj4EeEc', {
      :site => "https://www.google.com",
      :request_token_path => "/accounts/OAuthGetRequestToken",
      :access_token_path => "/accounts/OAuthGetAccessToken",
      :authorize_path => "/accounts/OAuthAuthorizeToken"
    })
  end

  def request_token
    @request_token ||= consumer.get_request_token({}, {:scope => "https://www.googleapis.com/auth/analytics.readonly"})
  end

  def auth_url
    request_token.authorize_url
  end

  def access_token
    @access_token ||= begin
      print 'OAuth Code: '
      code = $stdin.gets.strip
      request_token.get_access_token(:oauth_verifier => code)
    end
  end

  desc "Get a new OAuth Token"
  task :token do
    `open "#{auth_url}"`

    puts "Token: #{access_token.token}"
    puts "Secret: #{access_token.secret}"
  end
end
