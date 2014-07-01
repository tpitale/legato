require 'spec_helper'

describe Legato::Management::Profile do
  context "The Profile class" do
    def self.subject_class_name
      "profiles"
    end

    it_behaves_like "a management finder"

    it 'creates a new profile instance from a hash of attributes' do
      user = stub
      profile = Legato::Management::Profile.new({"id" => 12345, "name" => "Profile 1", "accountId" => "12345", "webPropertyId" => "UA-12345-2", "timezone" => "America/Edmonton"}, user)
      profile.user.should == user
      profile.id.should == 12345
      profile.name.should == "Profile 1"
      profile.account_id.should == "12345"
      profile.web_property_id.should == "UA-12345-2"

      profile.attributes["timezone"].should == "America/Edmonton"
      profile.attributes.has_key?("id").should eq(false)
    end

    it 'returns an array of all profiles available to a user under an account' do
      account = stub(:user => 'user', :path => 'accounts/12345')
      Legato::Management::Profile.stubs(:all)

      Legato::Management::Profile.for_account(account)

      Legato::Management::Profile.should have_received(:all).with('user', 'accounts/12345/webproperties/~all/profiles')
    end

    it 'returns an array of all profiles available to a user under an web property' do
      web_property = stub(:user => 'user', :path => 'accounts/12345/webproperties/UA-12345-3')
      Legato::Management::Profile.stubs(:all)

      Legato::Management::Profile.for_web_property(web_property)

      Legato::Management::Profile.should have_received(:all).with('user', 'accounts/12345/webproperties/UA-12345-3/profiles')
    end
  end

  context "A Profile instance" do
    it 'builds the path for the profile from the id' do
      profile = Legato::Management::Profile.new({"id" => 45678, "accountId" => "12345", "webPropertyId" => "UA-12345-3"}, stub)
      profile.path.should == '/accounts/12345/webproperties/UA-12345-3/profiles/45678'
    end
  end
end

