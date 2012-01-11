require 'spec_helper'

describe "Legato::Model" do
  context "A Class extended with Legato::Model" do
    def new_model_class
      Class.new.tap do |klass|
        klass.extend(Legato::Model)
      end
    end

    before :each do
      @model = new_model_class
    end

    it 'has a metric' do
      @model.metrics :exits
      @model.metrics.should == Legato::ListParameter.new(:metrics, [:exits])
    end

    it 'has metrics' do
      @model.metrics :exits, :pageviews
      @model.metrics.should == Legato::ListParameter.new(:metrics, [:exits, :pageviews])
    end

    it 'has a dimension' do
      @model.dimensions :browser
      @model.dimensions.should == Legato::ListParameter.new(:dimensions, [:browser])
    end

    it 'has dimensions' do
      @model.dimensions :browser, :city
      @model.dimensions.should == Legato::ListParameter.new(:dimensions, [:browser, :city])
    end

    context "with filters" do
      before :each do
        @block = lambda {}
      end

      it 'creates a class method' do
        @model.filter :high, @block
        @model.respond_to?(:high).should be_true
      end

      it 'stores the filter' do
        @model.filter :high, @block
        @model.filters[:high].should == @block
      end

      it 'returns a Query instance for a filter' do
        query = stub(:apply_filter => "a query")
        Legato::Query.stubs(:new).returns(query)

        @model.filter :high, @block
        @model.high('arg1').should == 'a query'

        Legato::Query.should have_received(:new).with(@model)
        query.should have_received(:apply_filter).with('arg1', @block)
      end
    end

    # xit 'has an instance klass'
    # xit 'sets an instance klass'

    it 'has results' do
      options = {}
      profile = stub
      query = stub(:results => "a query")
      Legato::Query.stubs(:new).returns(query)

      @model.results(profile, options).should == "a query"

      Legato::Query.should have_received(:new).with(@model)
      query.should have_received(:results).with(profile, options)
    end
  end
end
