require 'bundler'
Bundler.setup(:test)

require 'rspec'
require 'mocha'
require 'bourne'

require File.expand_path('../../lib/legato', __FILE__)

RSpec.configure do |config|
  config.mock_with :mocha
end

Dir["./spec/support/**/*.rb"].each {|f| require f}
