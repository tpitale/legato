require 'bundler'
Bundler.setup(:test)

require 'rspec'
require 'mocha'
require 'bourne'
require 'vcr'

require File.expand_path('../../lib/legato', __FILE__)

Dir["./spec/support/**/*.rb"].each {|f| require f; p f}

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path('../cassettes', __FILE__)
  config.default_cassette_options = {:record => :new_episodes, :serialize_with => :json}
end

RSpec.configure do |config|
  config.mock_with :mocha

  config.extend VCR::RSpec::Macros
  config.include Support::Macros::OAuth
end
