require 'spec_helper'

describe Legato::ListParameter do
  context "an instance of ListParameter" do
    before :each do
      @list_parameter = Legato::ListParameter.new(:metrics, [:exits])
    end

    it 'appends to the list' do
      @list_parameter << :pageviews
      @list_parameter.elements.should == [:exits, :pageviews]
    end

    it 'has a name' do
      @list_parameter.name.should == "metrics"
    end

    it 'knows if it is equal another list parameter' do
      @list_parameter.should == Legato::ListParameter.new(:metrics, [:exits])
    end

    it 'knows it is not equal another list parameter with a different name' do
      @list_parameter.should_not == Legato::ListParameter.new(:dimensions, [:exits])
    end

    it 'knows it is not equal another list parameter with different elements' do
      @list_parameter.should_not == Legato::ListParameter.new(:metrics, [:exits, :pageviews])
    end

    it 'converts itself to params' do
      @list_parameter << :pageviews
      @list_parameter.to_params("ga").should == {"metrics" => "ga:exits,ga:pageviews"}
    end
  end
end
