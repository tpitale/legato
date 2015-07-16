require 'spec_helper'

describe Legato::Management::AccountSummaries do
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

  context "The Account Summaries class" do
    def self.subject_class_name
      "account_summaries"
    end

    it_behaves_like "a management finder"

    it 'creates a new account summaries instance from a hash of attributes' do
      user = stub(:api_key => nil)
      account_summaries = Legato::Management::AccountSummaries.new(sample_dict, user)
      account_summaries.user.should == user
      account_summaries.account.id.should == 12345
      account_summaries.account.name.should == "Account 1"
      account_summaries.summary_web_properties.size.should == 2
      account_summaries.summary_profiles.size.should == 4
    end
  end
end
