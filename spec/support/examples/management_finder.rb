shared_examples_for "a management finder" do
  it "returns an array of all #{subject_class_name} available to a user" do
    JSON.stubs(:parse).returns({'items' => ['item1', 'item2']})
    response = stub(:body => 'some json')
    access_token = stub(:get => response)
    user = stub(:access_token => access_token)
    described_class.stubs(:new).returns('thing1', 'thing2')

    described_class.all(user).should == ['thing1', 'thing2']

    user.should have_received(:access_token)
    access_token.should have_received(:get).with('https://www.googleapis.com/analytics/v3/management'+described_class.default_path)
    response.should have_received(:body)
    JSON.should have_received(:parse).with('some json')
    described_class.should have_received(:new).with('item1', user)
    described_class.should have_received(:new).with('item2', user)
  end
end