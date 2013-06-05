shared_examples_for "a management finder" do
  let(:response) { stub(:body => 'some json') }
  let(:access_token) { access_token = stub(:get => response) }
  let(:user) { stub(:access_token => access_token, :api_key => nil) }

  after do
    user.should have_received(:access_token)
    access_token.should have_received(:get).with('https://www.googleapis.com/analytics/v3/management'+described_class.default_path)
    response.should have_received(:body)
    MultiJson.should have_received(:decode).with('some json')
  end

  it "returns an array of all #{subject_class_name} available to a user" do
    MultiJson.stubs(:decode).returns({'items' => ['item1', 'item2']})
    described_class.stubs(:new).returns('thing1', 'thing2')

    described_class.all(user).should == ['thing1', 'thing2']

    described_class.should have_received(:new).with('item1', user)
    described_class.should have_received(:new).with('item2', user)
  end

  it "returns an empty array of #{subject_class_name} when there are no results" do
    MultiJson.stubs(:decode).returns({})
    described_class.all(user).should == []

    described_class.should have_received(:new).never
  end
end
