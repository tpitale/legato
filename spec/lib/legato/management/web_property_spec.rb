require 'spec_helper'

describe Legato::Management::WebProperty do
  context "The WebProperty class" do
    def self.subject_class_name
      "web properties"
    end

    it_behaves_like "a management finder"

    it 'creates a new web property instance from a hash of attributes' do
      user = stub
      web_property = Legato::Management::WebProperty.new({"id" => 12345, "name" => "WebProperty 1", "websiteUrl" => "http://google.com"}, user)
      web_property.user.should == user
      web_property.id.should == 12345
      web_property.name.should == "WebProperty 1"
      web_property.website_url.should == 'http://google.com'
    end

    it 'returns an array of all web properties available to a user under an account' do
      account = stub(:user => 'user', :path => 'accounts/12345')
      Legato::Management::WebProperty.stubs(:all)
      Legato::Management::WebProperty.for_account(account)
      Legato::Management::WebProperty.should have_received(:all).with('user', 'accounts/12345/webproperties')
    end
  end

  context "A WebProperty instance" do
    it 'builds the path for the web_property from the id' do
      web_property = Legato::Management::WebProperty.new({"id" => 123456}, stub)
      web_property.path.should == '/accounts/~all/webproperties/123456'
    end
  end
end
