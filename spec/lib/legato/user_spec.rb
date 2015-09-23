require 'spec_helper'

describe Legato::User do
  context "an instance of Legato::User" do
    let(:klass) {Class.new}
    let(:query) {stub(:to_params => "params", :instance_klass => klass)}

    before :each do
      @access_token = stub
      @user = Legato::User.new(@access_token)
    end

    it 'returns a response for a given query' do
      @access_token.stubs(:get).returns('a response')
      Legato::Response.stubs(:new)
      query.stubs(:base_url).returns("the_api_url")

      @user.request(query)

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

    it 'has segments' do
      Legato::Management::Segment.stubs(:all)
      @user.segments
      Legato::Management::Segment.should have_received(:all).with(@user)
    end

    it 'has goals' do
      Legato::Management::Goal.stubs(:all)
      @user.goals
      Legato::Management::Goal.should have_received(:all).with(@user)
    end
  end
end
