require 'irb'
require 'yaml'
require 'oauth2'

module Legato

  module OAuth2Helpers
    def build_client(id, secret)
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

  class CLI
    def initialize
      config_path = File.join(ENV['HOME'], '.legato.yml')

      if File.exists?(config_path)
        @config = YAML.load_file(config_path) rescue {}
      else
        puts "##########################################################"
        puts "We can auto-load OAuth2 config from ~/.legato.yml"
        puts "##########################################################"

        build_config
      end

      build_access_token

      print_yaml unless File.exists?(config_path)
    end

    def run
      setup_irb
    end

    def setup_irb
      IRB.setup(nil)
      irb = IRB::Irb.new
      IRB.conf[:MAIN_CONTEXT] = irb.context
      irb.context.evaluate("require 'irb/completion'", 0)

      trap("SIGINT") do
        irb.signal_handle
      end
      catch(:IRB_EXIT) do
        irb.eval_input
      end
    end

    def client
      @client ||= OAuth2Helpers.build_client(@config['id'], @config['secret'])
    end

    def token
      @config['token']
    end

    def build_config
      @config ||= {}

      puts
      print 'Your OAuth2 id: '
      @config['id'] = $stdin.gets.strip
      print 'Your OAuth2 secret: '
      @config['secret'] = $stdin.gets.strip
    end

    def build_access_token
      if token
        @access_token = OAuth2::AccessToken.new(client, token)
      else
        puts
        puts "Opening the OAuth2 auth url: #{OAuth2Helpers.auth_url(client)} ..."
        `open "#{OAuth2Helpers.auth_url(client)}"`

        puts
        print 'OAuth2 Code (in the url): '
        code = $stdin.gets.strip

        @access_token = client.auth_code.get_token(code, :redirect_uri => 'http://localhost')
        @config['token'] = @access_token.token

        puts
        print "Your oauth token is #{@config['token']}"
        puts
      end
    end

    def build_user
      Legato::User.new(@access_token)
    end

    def print_yaml
      puts "##########################################################"
      puts "If you haven't already done so, you can make ~/.legato.yml"
      puts YAML.dump(@config)
      puts "##########################################################"
    end
  end
end
