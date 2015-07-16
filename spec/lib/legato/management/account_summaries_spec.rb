require 'spec_helper'

describe Legato::Management::AccountSummary do
  sample_dict = {
      :id => 12345,
      :kind => "analytics#accountSummary",
      :name => "Account 1",
      :webProperties => [
        {
        :kind => "analytics#webPropertySummary",
        :id => "UA-1",
        :name => "WebProperty1",
        :internalWebPropertyId => 123,
        :level => "STANDARD",
        :websiteUrl => "http://www.google.com",
        :profiles => [
          {
          :kind => "analytics#profileSummary",
          :id => "1234",
          :name => "Default",
          :type => "WEB"
          },
          {
          :kind => "analytics#profileSummary",
          :id => "1235",
          :name => "Ecommerce",
          :type => "WEB"
          },
          {
          :kind => "analytics#profileSummary",
          :id => "1236",
          :name => "Testing",
          :type => "WEB"
          }
        ]
        },
        {
        :kind => "analytics#webPropertySummary",
        :id => "UA-2",
        :name => "WebProperty2",
        :internalWebPropertyId => 456,
        :level => "STANDARD",
        :websiteUrl => "http://www.google.com",
        :profiles => [
          {
          :kind => "analytics#profileSummary",
          :id => "1237",
          :name => "Default",
          :type => "WEB"
          }
        ]
        }
      ]
  }

  context "The AccountSummary class" do
    def self.subject_class_name
      "account_summary"
    end

    before do
      @user = stub(:api_key => nil)
      puts sample_dict.inspect
      @account_summaries = Legato::Management::AccountSummary.new(sample_dict, @user)
    end

    it_behaves_like "a management finder"

    it 'creates a new account summary instance from a hash of attributes' do
      @account_summaries.user.should == @user
      @account_summaries.account.class == Legato::Management::Account
      @account_summaries.web_properties.first.class == Legato::Management::WebProperty
      @account_summaries.profiles.first.class == Legato::Management::Profile
    end

    it 'builds the account instance' do
      @account_summaries.account.id.should == 12345
      @account_summaries.account.name.should == "Account 1"
      @account_summaries.account.user.should == @user
    end

    it "builds the web_properties instances" do
      @account_summaries.web_properties.size.should == 2
      @account_summaries.web_properties.first.attributes[:kind].should == "analytics#webPropertySummary"
      @account_summaries.web_properties.first.attributes[:internalWebPropertyId].should == 123
      @account_summaries.web_properties.first.attributes[:level].should == "STANDARD"
      @account_summaries.web_properties.last.attributes[:kind].should == "analytics#webPropertySummary"
      @account_summaries.web_properties.last.attributes[:internalWebPropertyId].should == 456
      @account_summaries.web_properties.last.attributes[:level].should == "STANDARD"
    end

    it "builds the profiles" do
      @account_summaries.profiles.size.should == 4
      @account_summaries.profiles[0].attributes[:kind].should == "analytics#profileSummary"
      @account_summaries.profiles[0].attributes[:type].should == "WEB"
      @account_summaries.profiles[1].attributes[:kind].should == "analytics#profileSummary"
      @account_summaries.profiles[1].attributes[:type].should == "WEB"
      @account_summaries.profiles[2].attributes[:kind].should == "analytics#profileSummary"
      @account_summaries.profiles[2].attributes[:type].should == "WEB"
      @account_summaries.profiles[3].attributes[:kind].should == "analytics#profileSummary"
      @account_summaries.profiles[3].attributes[:type].should == "WEB"
    end
  end
end
