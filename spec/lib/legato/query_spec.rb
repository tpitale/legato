require 'spec_helper'

describe Legato::Query do
  def self.it_defines_operators(*operators)
    operators.each do |operator|
      it "creates a method for the operator #{operator}" do
        @query.respond_to?(operator).should be_true
      end

      it "returns a new filter for #{operator} to the set" do
        Legato::Filter.stubs(:new).returns("a filter")
        filter = @query.send(operator, :key, 2000)
        Legato::Filter.should have_received(:new).with(:key, operator, 2000)
      end
    end
  end

  context "a query" do
    before :each do
      @klass = Class.new
      @block = lambda {eql(:key, 1000)}
      @klass.stubs(:filters).returns({:high => @block})

      @query = Legato::Query.new(@klass)
    end

    it 'knows the parent class' do
      @query.parent_klass.should == @klass
    end

    it 'has filters defined from the parent class' do
      @query.respond_to?(:high).should be_true
    end

    it "has filter methods that call apply with the given block" do
      @query.stubs(:apply_filter)
      @query.high('hi')
      @query.should have_received(:apply_filter).with('hi', @block)
    end

    it 'does not load results by default' do
      @query.loaded?.should == false
    end

    it "loads a collection of results" do
      request = stub(:parsed_response => [1,2,3])
      Legato::Request.stubs(:new).returns(request)
      @query.load
      @query.loaded?.should be_true
      Legato::Request.should have_received(:new).with(@query)
      request.should have_received(:parsed_response)
    end

    it "returns the collection" do
      request = stub(:parsed_response => [1,2,3])
      Legato::Request.stubs(:new).returns(request)
      @query.load
      @query.collection.should == [1,2,3]
      @query.to_a.should == [1,2,3]
    end

    context 'when applying filters' do
      before :each do
        @query.stubs(:eql)
      end

      it 'returns the query' do
        @query.apply_filter(@block).should == @query
      end

      it 'executes the block' do
        @query.apply_filter(@block)
        @query.should have_received(:eql).with(:key, 1000)
      end

      it 'accepts a profile as the first argument' do
        profile = Legato::Management::Profile.new({}, stub)
        @query.apply_filter(profile, @block)
        @query.should have_received(:eql)
        @query.profile.should == profile
      end

      it 'accepts a profile as the last argument' do
        profile = Legato::Management::Profile.new({}, stub)
        block_with_arg = lambda {|count| eql(:key, count)}
        @query.apply_filter(100, profile, block_with_arg)
        @query.should have_received(:eql).with(:key, 100)
        @query.profile.should == profile
      end
    end

    context "when applying options" do
      it "returns the query" do
        @query.apply_options({}).should == @query
      end

      it "stores the order" do
        @query.apply_options({:order => [:page_path]})
        @query.order.should == [:page_path]
      end

      it 'replaces the order' do
        @query.order = [:pageviews]
        @query.apply_options({:order => [:page_path]})
        @query.order.should == [:page_path]
      end

      it "does not replace order if option is omitted" do
        @query.order = [:pageviews]
        @query.apply_options({})
        @query.order.should == [:pageviews]
      end

      it "moves :sort option into order" do
        @query.apply_options({:sort => [:page_path]})
        @query.order.should == [:page_path]
      end

      it "sets the limit" do
        @query.apply_options({:limit => 100})
        @query.limit.should == 100
      end

      it "replaces the limit" do
        @query.limit = 200
        @query.apply_options({:limit => 100})
        @query.limit.should == 100
      end

      it "does not replace the limit if option is omitted" do
        @query.limit = 200
        @query.apply_options({})
        @query.limit.should == 200
      end

      it "sets the offset" do
        @query.apply_options({:offset => 100})
        @query.offset.should == 100
      end

      it "replaces the offset" do
        @query.offset = 200
        @query.apply_options({:offset => 100})
        @query.offset.should == 100
      end

      it "does not replace offset if option is omitted" do
        @query.offset = 200
        @query.apply_options({})
        @query.offset.should == 200
      end

      context "with Time" do
        before :each do
          @now = Time.now
          Time.stubs(:now).returns(@now)
        end

        it 'defaults the start date to 30 days ago' do
        end

        it "replaces the start date" do
          @query.apply_options({:start_date => (@now-2000)})
          @query.start_date.should == (@now-2000)
        end

        it "does not replace the start date if option is omitted" do
          @query.apply_options({})
          Legato.format_time(@query.start_date).should == Legato.format_time(@now-Legato::Query::MONTH)
        end

        it "replaces the end date" do
          @query.apply_options({:end_date => (@now+2000)})
          @query.end_date.should == (@now+2000)
        end

        it "does not replace the end date if option is omitted" do
          @query.apply_options({})
          Legato.format_time(@query.end_date).should == Legato.format_time(@now)
        end
      end
    end

    it_defines_operators :eql, :not_eql, :gt, :gte, :lt, :lte, :matches,
      :does_not_match, :contains, :does_not_contain, :substring, :not_substring
  end
end