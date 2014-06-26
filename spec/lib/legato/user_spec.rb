require 'spec_helper'

describe Legato::User do
  context "an instance of Legato::User with the scope set" do
    let(:user) {user = Legato::User.new(@access_token, nil)}

    before :each do
      @access_token = stub
    end

    it 'raises when an invalid scope is passed in' do
      expect { user.url_for(stub(:tracking_scope => "what"))}.to raise_error
    end

    it 'sets the correct endpoint url' do
      user.url_for(stub(:tracking_scope => 'mcf')).should == "https://www.googleapis.com/analytics/v3/data/mcf"
    end
  end

  context "an instance of Legato::User" do
    before :each do
      @access_token = stub
      @user = Legato::User.new(@access_token)
    end

    it 'has the correct api endpoint' do
      @user.url_for(stub(:tracking_scope => 'ga')).should == "https://www.googleapis.com/analytics/v3/data/ga"
    end

    it 'has the realtime api endpoint' do
      @user.url_for(stub(:tracking_scope => 'rt')).should == "https://www.googleapis.com/analytics/v3/data/realtime"
    end

    it 'returns a response for a given query' do
      klass = Class.new
      @access_token.stubs(:get).returns('a response')
      Legato::Response.stubs(:new)
      @user.stubs(:url_for).returns("the_api_url")

      @user.request(stub(:to_params => "params", :instance_klass => klass))

      Legato::Response.should have_received(:new).with('a response', klass)
      @access_token.should have_received(:get).with("the_api_url", :params => "params")
    end

    it 'has accounts' do
      Legato::Management::Account.stubs(:all)
      @user.accounts
      Legato::Management::Account.should have_received(:all).with(@user)
    end

    it 'has web_properties' do
      Legato::Management::WebProperty.stubs(:all)
      @user.web_properties
      Legato::Management::WebProperty.should have_received(:all).with(@user)
    end

    it 'has profiles' do
      Legato::Management::Profile.stubs(:all)
      @user.profiles
      Legato::Management::Profile.should have_received(:all).with(@user)
    end
  end
end
