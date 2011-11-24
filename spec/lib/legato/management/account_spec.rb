require 'spec_helper'

describe Legato::Management::Account do
  context "The Account class" do
    def self.subject_class_name
      "accounts"
    end

    it_behaves_like "a management finder"

    it 'creates a new account instance from a hash of attributes' do
      user = stub
      account = Legato::Management::Account.new({"id" => 12345, "name" => "Account 1"}, user)
      account.user.should == user
      account.id.should == 12345
      account.name.should == "Account 1"
    end
  end

  context "An Account instance" do
    it 'builds the path for the account from the id' do
      account = Legato::Management::Account.new({"id" => 123456}, stub)
      account.path.should == '/accounts/123456'
    end
  end
end
