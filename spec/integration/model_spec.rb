require 'spec_helper'

class ModelTest
  extend Legato::Model

  metrics :pageviews, :exits
  dimensions :operating_system
end

describe 'Legato::Model' do
  context "A class extended with Legato::Model" do
    use_vcr_cassette 'model/basic'

    it 'returns results for the metrics and dimensions' do
      user = Legato::User.new(access_token)
      profile = Legato::Management::Profile.new({'id' => 4506212, 'name' => 'Some Site'}, user)
      ModelTest.results(profile).should_not be_nil
    end
  end
end
