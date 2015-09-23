require 'spec_helper'

describe Legato::User do
  context "an instance of Legato::User" do
    let(:instance_klass) { Class.new }
    let(:klass) { Class.new.tap {|k| k.extend(Legato::Model)} }
    let(:query) { Legato::Query.new(klass) }
    let(:access_token) { stub }
    let(:user) { Legato::User.new(access_token) }

    before(:each) do
      query.stubs(:instance_klass).returns(instance_klass)
    end

    it 'assigns a quota user to the query' do
      Legato::Request.stubs(:new).returns(stub(:response => 'response'))

      user.quota_user = 'user12345678'
      user.request(query)

      expect(query.to_params['quotaUser']).to eql('user12345678')
    end

    it 'assigns a user ip to the query' do
      Legato::Request.stubs(:new).returns(stub(:response => 'response'))

      user.user_ip = '127.0.0.1'
      user.request(query)

      expect(query.to_params['userIp']).to eql('127.0.0.1')
    end

    it 'returns a response for a given query' do
      query.stubs(:to_params).returns('params')
      access_token.stubs(:get).returns('a response')
      Legato::Response.stubs(:new)
      query.stubs(:base_url).returns("the_api_url")

      user.request(query)

      Legato::Response.should have_received(:new).with('a response', instance_klass)
      access_token.should have_received(:get).with("the_api_url", :params => "params")
    end

    it 'has accounts' do
      Legato::Management::Account.stubs(:all)
      user.accounts
      Legato::Management::Account.should have_received(:all).with(user)
    end

    it 'has web_properties' do
      Legato::Management::WebProperty.stubs(:all)
      user.web_properties
      Legato::Management::WebProperty.should have_received(:all).with(user)
    end

    it 'has profiles' do
      Legato::Management::Profile.stubs(:all)
      user.profiles
      Legato::Management::Profile.should have_received(:all).with(user)
    end

    it 'has segments' do
      Legato::Management::Segment.stubs(:all)
      user.segments
      Legato::Management::Segment.should have_received(:all).with(user)
    end

    it 'has goals' do
      Legato::Management::Goal.stubs(:all)
      user.goals
      Legato::Management::Goal.should have_received(:all).with(user)
    end
  end
end
