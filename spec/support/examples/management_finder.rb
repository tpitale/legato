shared_examples_for "a management finder" do
  let(:response) { stub(:body => 'some json') }
  let(:access_token) { stub(:get => response) }
  let(:user) { Legato::User.new(access_token, nil) }

  context ".all" do
    it "returns an array of all #{subject_class_name} available to a user" do
      MultiJson.stubs(:decode).returns({'items' => ['item1', 'item2']})
      described_class.stubs(:new).returns('thing1', 'thing2')

      described_class.all(user).should == ['thing1', 'thing2']

      described_class.should have_received(:new).with('item1', user)
      described_class.should have_received(:new).with('item2', user)

      access_token.should have_received(:get).with('https://www.googleapis.com/analytics/v3/management'+described_class.default_path, :params => {})
      response.should have_received(:body)
      MultiJson.should have_received(:decode).with('some json')
    end

    it "returns an empty array of #{subject_class_name} when there are no results" do
      MultiJson.stubs(:decode).returns({})
      described_class.all(user).should == []

      described_class.should have_received(:new).never
    end
  end

  context ".get" do
    it "returns an instance of #{subject_class_name} for a given path" do
      MultiJson.stubs(:decode).returns('attributes')
      described_class.stubs(:new).returns('thing')

      path = '/path'

      expect(described_class.get(user, path)).to eq('thing')
      expect(described_class).to have_received(:new).with('attributes', user)

      access_token.should have_received(:get).with('https://www.googleapis.com/analytics/v3/management/path', :params => {})
      response.should have_received(:body)
      MultiJson.should have_received(:decode).with('some json')
    end
  end
end
