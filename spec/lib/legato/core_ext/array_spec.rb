require File.expand_path('../../../../../lib/legato/core_ext/array', __FILE__)

module Test
  class ObjectWithArray
    def to_ary
      [self]
    end
  end

  class ObjectWithoutArray
  end

  class ProxiedArray < Array
    undef_method :to_ary
  end
end

describe Array, 'Core Extension Methods' do
  let(:without_array) { Test::ObjectWithoutArray.new }
  let(:with_array) { Test::ObjectWithArray.new }
  let(:nil_object) { nil }
  let(:proxied_array) { Test::ProxiedArray.new([1,2,3]) }

  subject { described_class }

  context "object without #to_ary" do
    it "wraps the object in an array" do
      subject.wrap(without_array).should == [without_array]
    end
  end

  context "object with #to_ary" do
    it "delegates #to_ary to the object" do
      subject.wrap(with_array).should == [with_array]
    end
  end

  context "with nil object" do
    it "returns an empty array" do
      subject.wrap(nil_object).should == []
    end
  end

  context "general objects" do
    it "returns the string in an array" do
      subject.wrap('Hello').should == ['Hello']
    end

    it "returns the integer in an array" do
      subject.wrap(1).should == [1]
    end

    it "returns the flattened array" do
      subject.wrap([1,2,3]).should == [1,2,3]
    end

    it "returns an array in an array" do
      subject.wrap(proxied_array).should == [[1,2,3]]
    end

    it "returns a float in an array" do
      subject.wrap(1.2).should == [1.2]
    end

    it "returns a hash in an array" do
      subject.wrap({ :data => [1,2] }).should == [{ :data => [1,2] }]
    end
  end
end
