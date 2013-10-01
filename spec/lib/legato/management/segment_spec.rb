require 'spec_helper'

describe Legato::Management::Segment do
  context "The Segment class" do
    def self.subject_class_name
      "segments"
    end

    it_behaves_like "a management finder"

    it 'creates a new segment instance from a hash of attributes' do
      user = stub(:api_key => nil)
      segment = Legato::Management::Segment.new({"id" => 12345, "name" => "Segment 1", "definition" => "Some Segment"}, user)
      segment.user.should == user
      segment.id.should == 12345
      segment.name.should == "Segment 1"
      segment.definition.should == "Some Segment"
    end
  end
end
