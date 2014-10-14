require 'spec_helper'

describe Legato::Management::Account do
  context "The Account class" do
    def self.subject_class_name
      "accounts"
    end

    it_behaves_like "a management finder"

    it 'creates a new account instance from a hash of attributes' do
      user = stub(:api_key => nil)
      account = Legato::Management::Account.new({"id" => 12345, "name" => "Account 1"}, user)
      account.user.should == user
      account.id.should == 12345
      account.name.should == "Account 1"
    end

    it 'finds an instance from a child management instance' do
      user = stub(:api_key => nil)
      profile = Legato::Management::Profile.new({:account_id => 123}, user)
      # account = Legato::Management::Account
    end
  end

  context "An Account instance" do
    let(:account) {Legato::Management::Account.new({"id" => 123456}, stub)}

    it 'builds the path for the account from the id' do
      account.path.should == '/accounts/123456'
    end

    it 'has web properties beneath it' do
      Legato::Management::WebProperty.stubs(:for_account).returns('web_properties')
      account.web_properties.should == 'web_properties'
      Legato::Management::WebProperty.should have_received(:for_account).with(account)
    end

    it 'has profiles beneath it' do
      Legato::Management::Profile.stubs(:for_account).returns('profiles')
      account.profiles.should == 'profiles'
      Legato::Management::Profile.should have_received(:for_account).with(account)
    end
  end
end
