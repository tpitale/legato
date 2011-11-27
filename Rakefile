require "bundler/gem_tasks"

require 'oauth2'

namespace :oauth do
  def client
    OAuth2::Client.new('779170787975.apps.googleusercontent.com', 'mbCISoZiSwyVQIDEbLj4EeEc', :authorize_url => 'https://accounts.google.com/o/oauth2/auth', :token_url => 'https://accounts.google.com/o/oauth2/token')
  end

  def auth_url
    client.auth_code.authorize_url(:scope => 'https://www.googleapis.com/auth/analytics.readonly', :redirect_uri => 'http://localhost')
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