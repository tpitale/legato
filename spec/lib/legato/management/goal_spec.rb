require 'spec_helper'

describe Legato::Management::Goal do
  context "The Goal class" do
    def self.subject_class_name
      "goals"
    end

    it_behaves_like "a management finder"

    it 'creates a new goal instance from a hash of attributes' do
      user = stub
      goal = Legato::Management::Goal.new({"id" => 12345, "name" => "Goal 1", "webPropertyId" => "WebProperty 7", "profileId" => "Profile 111", "value" => "/blah"}, user)
      goal.user.should == user
      goal.id.should == 12345
      goal.name.should == "Goal 1"
      goal.web_property_id.should == "WebProperty 7"
      goal.profile_id.should == "Profile 111"

      goal.attributes["value"].should == "/blah"
      goal.attributes.has_key?("id").should eq(false)
    end

    it 'returns an array of all goals available to a user under an account' do
      account = stub(:user => 'user', :path => 'accounts/12345')
      Legato::Management::Goal.stubs(:all)

      Legato::Management::Goal.for_account(account)

      Legato::Management::Goal.should have_received(:all).with('user', 'accounts/12345/webproperties/~all/profiles/~all/goals')
    end

    it 'returns an array of all goals available to a user under an web property' do
      web_property = stub(:user => 'user', :path => 'accounts/~all/webproperties/12345')
      Legato::Management::Goal.stubs(:all)

      Legato::Management::Goal.for_web_property(web_property)

      Legato::Management::Goal.should have_received(:all).with('user', 'accounts/~all/webproperties/12345/profiles/~all/goals')
    end

    it 'returns an array of all goals available to a user under a profile' do
      profile = stub(:user => 'user', :path => 'accounts/~all/webproperties/~all/profiles/12345')
      Legato::Management::Goal.stubs(:all)

      Legato::Management::Goal.for_profile(profile)

      Legato::Management::Goal.should have_received(:all).with('user', 'accounts/~all/webproperties/~all/profiles/12345/goals')
    end
  end

  context "A Goal instance" do
    it 'builds the path for the goal from the id' do
      goal = Legato::Management::Goal.new({"id" => 12345}, stub)
      goal.path.should == '/accounts/~all/webproperties/~all/profiles/~all/goals/12345'
    end
  end
end
