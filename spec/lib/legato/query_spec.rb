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
        Legato::Filter.should have_received(:new).with(:key, operator, 2000, nil)
      end
    end
  end

  context "a query" do
    before :each do
      @klass = Class.new
      @klass.extend(Legato::Model)
      @block = lambda {eql(:key, 1000)}
      @klass.stubs(:filters).returns({:high => @block})
      @klass.stubs(:segments).returns([])

      @query = Legato::Query.new(@klass)
    end

    it 'knows the parent class' do
      @query.parent_klass.should == @klass
    end

    it 'defaults to an empty filter set' do
      @query.filters.to_params.should == Legato::FilterSet.new.to_params
    end

    it 'has filters defined from the parent class' do
      @query.respond_to?(:high).should be_true
    end

    it "has filter methods that call apply with the given block" do
      @query.stubs(:apply_filter)
      @query.high('hi')
      @query.should have_received(:apply_filter).with('hi')
    end

    it 'does not load results by default' do
      @query.loaded?.should == false
    end

    it 'delegates the instance klass from the parent klass' do
      klass = Class.new
      @query.parent_klass.stubs(:instance_klass).returns(klass)
      @query.instance_klass.should == klass
    end

    it "loads a collection of results" do
      response = stub(:collection => [], :total_results => 0, :totals_for_all_results => {})
      user = stub(:request => response)
      @query.stubs(:profile => stub(:user => user))

      @query.load

      @query.loaded?.should be_true
      @query.profile.user.should have_received(:request).with(@query)
      response.should have_received(:collection)
      response.should have_received(:total_results)
      response.should have_received(:totals_for_all_results)
    end

    it "returns the collection" do
      @query.stubs(:request_for_query).returns(stub(:collection => [1,2,3], :total_results => 3, :totals_for_all_results => {'foo' => 34.2}))
      @query.load
      @query.collection.should == [1,2,3]
      @query.to_a.should == [1,2,3]
    end

    it "returns the total number of results" do
      @query.stubs(:request_for_query).returns(stub(:collection => [1,2,3], :total_results => 3, :totals_for_all_results => {'foo' => 34.2}))
      @query.load
      @query.total_results.should == 3
    end

    it "returns the totals for all results" do
      @query.stubs(:request_for_query).returns(stub(:collection => [1,2,3], :total_results => 3, :totals_for_all_results => {'foo' => 34.2}))
      @query.load
      @query.totals_for_all_results.should == {'foo' => 34.2}
    end

    it "behaves like an enumerable delegating to the collection" do
      collection = []
      collection.stubs(:each)
      @query.stubs(:collection).returns(collection)
      @query.stubs(:loaded?).returns(true)

      @query.each {}

      collection.should have_received(:each)
    end

    it 'has a profile id after being given a profile' do
      profile = stub(:id => '1234567890')
      @query.stubs(:profile).returns(profile)

      @query.profile_id.should == 'ga:1234567890'

      profile.should have_received(:id)
    end

    it 'has no profile id by default' do
      @query.stubs(:profile).returns(nil)
      @query.profile_id.should be_nil
    end

    it 'sets the profile and applies options, returns itself' do
      @query.stubs(:profile=)
      @query.stubs(:apply_options)

      @query.results('profile').should == @query

      @query.should have_received(:profile=).with('profile')
      @query.should have_received(:apply_options).with({})
    end

    it 'sets options and returns self' do
      @query.stubs(:profile=)
      @query.stubs(:apply_options)

      @query.results({:sort => [:city]}).should == @query

      @query.should have_received(:profile=).never
      @query.should have_received(:apply_options).with({:sort => [:city]})
    end

    context "when modifying dimensions" do
      it 'changes the query dimensions' do
        @query.dimensions << :city
        @query.dimensions.include?(:city).should be_true
      end

      it 'does not change the parent class dimensions' do
        empty_dimensions = Legato::ListParameter.new(:dimensions, [])

        @query.dimensions << :city
        @klass.dimensions.should eq(empty_dimensions)
      end
    end

    context "when modifying metrics" do
      it 'changes the query metrics' do
        @query.metrics << :pageviews
        @query.metrics.include?(:pageviews).should be_true
      end

      it 'does not change the parent class metrics' do
        empty_metrics = Legato::ListParameter.new(:metrics, [])

        @query.metrics << :pageviews
        @klass.metrics.should eq(empty_metrics)
      end
    end

    context 'when applying filters' do
      before :each do
        @filter = Legato::Filter.new(:key, :eql, 1000, nil)
        @query.stubs(:eql).returns(@filter)

        @filters = stub(:<<)
        @query.stubs(:filters).returns(@filters)
      end

      it 'returns the query' do
        @query.apply_filter(&@block).should == @query
      end

      it 'executes the block' do
        @query.apply_filter(&@block)
        @query.should have_received(:eql).with(:key, 1000)
      end

      it 'accepts a profile as the first argument' do
        profile = Legato::Management::Profile.new({}, stub)
        @query.apply_filter(profile, &@block)
        @query.should have_received(:eql)
        @query.profile.should == profile
      end

      it 'accepts a profile as the last argument' do
        profile = Legato::Management::Profile.new({}, stub)
        block_with_arg = lambda {|count| eql(:key, count)}
        @query.apply_filter(100, profile, &block_with_arg)
        @query.should have_received(:eql).with(:key, 100)
        @query.profile.should == profile
      end

      it 'does not override the existing profile if none is provide' do
        @query.profile = Legato::Management::Profile.new({}, stub)
        block_with_arg = lambda {|count| eql(:key, count)}
        @query.apply_filter(100, &block_with_arg)
        @query.profile.should_not == nil
      end

      it 'adds to the filter set' do
        @query.apply_filter(&@block)

        @filters.should have_received(:<<).with(@filter)
      end

      it 'joins an array of filters with OR' do
        block = lambda {|*browsers| browsers.map {|browser| eql(:browser, browser)}}
        @filter.stubs(:join_character=)

        @query.apply_filter('chrome', 'safari', &block)

        @filter.should have_received(:join_character=).with(Legato.and_join_character)
        @filter.should have_received(:join_character=).with(Legato.or_join_character)
      end
    end

    context "when applying options" do
      it "returns the query" do
        @query.apply_options({}).should == @query
      end

      it "stores the sort" do
        @query.apply_options({:sort => [:page_path]})
        @query.sort.should == Legato::ListParameter.new(:sort, [:page_path])
      end

      it 'replaces the sort' do
        @query.sort = [:pageviews]
        @query.apply_options({:sort => [:page_path]})
        @query.sort.should == Legato::ListParameter.new(:sort, [:page_path])
      end

      it "does not replace sort if option is omitted" do
        @query.sort = [:pageviews]
        @query.apply_options({})
        @query.sort.should == Legato::ListParameter.new(:sort, [:pageviews])
      end

      it "moves :sort option into sort" do
        @query.apply_options({:sort => [:page_path]})
        @query.sort.should == Legato::ListParameter.new(:sort, [:page_path])
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

      it "sets the quota_user" do
        @query.apply_options({:quota_user => 'an id'})
        @query.quota_user.should == 'an id'
      end

      it "replaces the quota_user" do
        @query.quota_user = 'an id'
        @query.apply_options({:quota_user => 'a different id'})
        @query.quota_user.should == 'a different id'
      end

      it "does not replace quota_user if option is omitted" do
        @query.quota_user = 'an id'
        @query.apply_options({})
        @query.quota_user.should == 'an id'
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

    context "as a hash of parameters" do
      before :each do
        @query.stubs(:metrics).returns(nil)
        @query.stubs(:dimensions).returns(nil)
        @query.stubs(:filters).returns(stub(:to_params => nil))
      end

      it 'includes the profile id' do
        @query.stubs(:profile_id).returns('ga:1234567890')

        @query.to_params.should == {
          'ids' => 'ga:1234567890',
          'start-date' => Legato.format_time(Time.now-Legato::Query::MONTH),
          'fields' => Legato::Query::REQUEST_FIELDS,
          'end-date' => Legato.format_time(Time.now)
        }
      end

      it 'includes the start and end dates' do
        now = Time.now
        @query.start_date = now
        @query.end_date = now
        @query.to_params.should == {
          'start-date' => Legato.format_time(now),
          'fields' => Legato::Query::REQUEST_FIELDS,
          'end-date' => Legato.format_time(now)
        }
      end

      it 'includes the limit' do
        @query.limit = 1000
        @query.to_params['max-results'].should == 1000
      end

      it 'includes the offset' do
        @query.offset = 50
        @query.to_params['start-index'].should == 50
      end

      it 'includes the quotaUser if quota_user is set' do
        @query.quota_user = 'an id'
        @query.to_params['quotaUser'].should == 'an id'
      end

      it 'excludes the quotaUser if quota_user is not set' do
        @query.to_params.keys.should_not include('quotaUser')
      end

      it 'includes filters' do
        filters = stub(:to_params => 'filter set parameters')
        @query.stubs(:filters).returns(filters)

        @query.to_params['filters'].should == 'filter set parameters'
      end

      it 'includes the dynamic segment' do
        segment_filters = stub(:to_params => 'segment parameter', :any? => true)
        @query.stubs(:segment_filters).returns(segment_filters)

        @query.to_params['segment'].should == 'dynamic::segment parameter'
      end

      it 'includes metrics' do
        metrics = Legato::ListParameter.new(:metrics)
        metrics.stubs(:to_params).returns({'metrics' => 'pageviews,exits'})
        metrics.stubs(:empty?).returns(false)
        @query.stubs(:metrics).returns(metrics)

        @query.to_params['metrics'].should == 'pageviews,exits'
      end

      it 'includes dimensions' do
        dimensions = Legato::ListParameter.new(:dimensions)
        dimensions.stubs(:to_params).returns({'dimensions' => 'browser,country'})
        dimensions.stubs(:empty?).returns(false)
        @query.stubs(:dimensions).returns(dimensions)

        @query.to_params['dimensions'].should == 'browser,country'
      end

      it 'includes sort' do
        sort = Legato::ListParameter.new(:sort)
        sort.stubs(:to_params).returns({'sort' => 'pageviews'})
        sort.stubs(:empty?).returns(false)
        @query.stubs(:sort).returns(sort)

        @query.to_params['sort'].should == 'pageviews'
      end
    end
  end
end
