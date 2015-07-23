require 'spec_helper'

describe Legato::Management::AccountSummary do
  let(:sample_dict) {
    {
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
              :kind => "analytics#profileSummary1",
              :id => 1234,
              :name => "Default",
              :type => "WEB1"
            },
            {
              :kind => "analytics#profileSummary2",
              :id => 1235,
              :name => "Ecommerce",
              :type => "WEB2"
            },
            {
              :kind => "analytics#profileSummary3",
              :id => 1236,
              :name => "Testing",
              :type => "WEB3"
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
              :kind => "analytics#profileSummary4",
              :id => 1237,
              :name => "Default",
              :type => "WEB4"
            }
          ]
        }
      ]
    }
  }

  let(:user) { stub(:api_key => nil) }
  let(:account_summary) { Legato::Management::AccountSummary.new(sample_dict, user) }

  def self.subject_class_name
    "account_summary"
  end

  context "The AccountSummary class" do
    it_behaves_like "a management finder"

    it 'has the correct paths' do
      Legato::Management::AccountSummary.default_path.should == '/accountSummaries'
      Legato::Management::AccountSummary.new(sample_dict, user).path.should == ''
    end

    it 'creates a new account summary instance from a hash of attributes' do
      account_summary.user.should == user
      account_summary.account.class == Legato::Management::Account
      account_summary.web_properties.first.class == Legato::Management::WebProperty
      account_summary.profiles.first.class == Legato::Management::Profile
    end
  end

  context "builds proper instances" do
    it 'builds the account instance' do
      account_summary.account.id.should == 12345
      account_summary.account.name.should == "Account 1"
      account_summary.account.user.should == user
    end

    it "builds the web_properties instances" do
      account_summary.web_properties.size.should == 2
      account_summary.web_properties.first.attributes[:kind].should == "analytics#webPropertySummary"
      account_summary.web_properties.first.id.should == "UA-1"
      account_summary.web_properties.first.name.should == "WebProperty1"
      account_summary.web_properties.first.account_id.should == 12345
      account_summary.web_properties.first.attributes[:internalWebPropertyId].should == 123
      account_summary.web_properties.first.attributes[:level].should == "STANDARD"
      account_summary.web_properties.last.attributes[:kind].should == "analytics#webPropertySummary"
      account_summary.web_properties.last.id.should == "UA-2"
      account_summary.web_properties.last.name.should == "WebProperty2"
      account_summary.web_properties.last.account_id.should == 12345
      account_summary.web_properties.last.attributes[:internalWebPropertyId].should == 456
      account_summary.web_properties.last.attributes[:level].should == "STANDARD"
    end

    it "builds the profiles" do
      account_summary.profiles.size.should == 4
      account_summary.profiles[0].attributes[:kind].should == "analytics#profileSummary1"
      account_summary.profiles[0].id.should == 1234
      account_summary.profiles[0].name.should == "Default"
      account_summary.profiles[0].account_id.should == 12345
      account_summary.profiles[0].web_property_id.should == "UA-1"
      account_summary.profiles[0].attributes[:type].should == "WEB1"
      account_summary.profiles[1].attributes[:kind].should == "analytics#profileSummary2"
      account_summary.profiles[1].id.should == 1235
      account_summary.profiles[1].name.should == "Ecommerce"
      account_summary.profiles[1].account_id.should == 12345
      account_summary.profiles[1].web_property_id.should == "UA-1"
      account_summary.profiles[1].attributes[:type].should == "WEB2"
      account_summary.profiles[2].attributes[:kind].should == "analytics#profileSummary3"
      account_summary.profiles[2].id.should == 1236
      account_summary.profiles[2].name.should == "Testing"
      account_summary.profiles[2].account_id.should == 12345
      account_summary.profiles[2].web_property_id.should == "UA-1"
      account_summary.profiles[2].attributes[:type].should == "WEB3"
      account_summary.profiles[3].attributes[:kind].should == "analytics#profileSummary4"
      account_summary.profiles[3].id.should == 1237
      account_summary.profiles[3].name.should == "Default"
      account_summary.profiles[3].account_id.should == 12345
      account_summary.profiles[3].web_property_id.should == "UA-2"
      account_summary.profiles[3].attributes[:type].should == "WEB4"
    end
  end

  context "allows forward and reverse traversing" do
    it "can be used for reverse traversing to web_property from profiles" do
      account_summary.profiles[0].web_property.should == account_summary.web_properties[0]
      account_summary.profiles[1].web_property.should == account_summary.web_properties[0]
      account_summary.profiles[2].web_property.should == account_summary.web_properties[0]
      account_summary.profiles[3].web_property.should == account_summary.web_properties[1]
    end

    it "can be used for reverse traversing to account from profiles" do
      account_summary.profiles[0].account.should == account_summary.account
      account_summary.profiles[1].account.should == account_summary.account
      account_summary.profiles[2].account.should == account_summary.account
      account_summary.profiles[3].account.should == account_summary.account
    end

    it "can be used for reverse traversing to account from web_properties" do
      account_summary.web_properties[0].account.should == account_summary.account
      account_summary.web_properties[1].account.should == account_summary.account
    end

    it "can be used for traversing to profiles from web_properties" do
      account_summary.web_properties[0].profiles.size.should == 3
      account_summary.web_properties[0].profiles[0].id.should == 1234
      account_summary.web_properties[0].profiles[1].id.should == 1235
      account_summary.web_properties[0].profiles[2].id.should == 1236
      account_summary.web_properties[1].profiles.size.should == 1
      account_summary.web_properties[1].profiles[0].id.should == 1237
    end

    it "can be used for traversing to web_properties from accounts" do
      account_summary.account.web_properties.should == account_summary.web_properties
    end

    it "can be used for traversing to profiles from accounts" do
      account_summary.account.profiles.should == account_summary.profiles
    end
  end
end
