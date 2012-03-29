require 'spec_helper'

describe Legato::Response do
  context "An instance of Response" do
    before :each do
      raw_body = File.read(File.dirname(__FILE__) + '/../../fixtures/simple_response.json')

      @response = Legato::Response.new(stub(:body => raw_body))
    end

    it 'has a collection of OpenStruct instances' do
      @response.collection.first.should == OpenStruct.new({:browser=>"Android Browser", :pageviews=>"93"})
    end

    it 'has the number of total results' do
      @response.total_results.should == 13
    end

    it 'has the totals for all results hash' do
      @response.totals_for_all_results.should == {'pageviews' => 3710}
    end

    it 'handles no rows returned' do
      @response.stubs(:data).returns({'rows' => nil})
      @response.collection.should == []
    end
  end
end
