require 'spec_helper'

describe "Management" do
  before :each do
    @user = Legato::User.new(access_token)
  end

  context "Management::Account" do
    use_vcr_cassette 'management/accounts'

    it 'has accounts' do
      accounts = Legato::Management::Account.all(@user)
      accounts.map(&:id).should == ["1189765", "3879168", "7471517", "11360836", "11917142", "17306519"]
    end
  end

  context "Management::WebProperty" do
    use_vcr_cassette 'management/web_properties'

    it 'has web properties' do
      web_properties = Legato::Management::WebProperty.all(@user)
      web_properties.map(&:id).include?("UA-1189765-4").should == true
    end
  end

  context "Management::Profile" do
    use_vcr_cassette 'management/profiles'

    it 'has profiles' do
      profiles = Legato::Management::Profile.all(@user)
      profiles.map(&:id).include?("4506212").should == true
    end
  end

  context "Management::Finder without results" do
    use_vcr_cassette 'management/no_profiles'

    it 'has no profiles' do
      profiles = Legato::Management::Profile.all(@user)
      profiles.map(&:id).should == []
    end
  end
end
