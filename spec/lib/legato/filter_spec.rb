require 'spec_helper'

describe Legato::Filter do
  let(:klass) { Class.new.tap { |k| k.extend(Legato::Model)} }
  let(:query) { Legato::Query.new(klass) }

  context "a Filter instance with mcf" do
    before :each do
      query.tracking_scope = 'mcf'

      @filter = Legato::Filter.new(query, :exits, :lt, 1000, nil)
    end

    it 'represents itself as a parameter' do
      @filter.to_param.should == "mcf:exits<1000"
    end

    it 'joins with another filter' do
      filter2 = Legato::Filter.new(query, :pageviews, :gt, 1000, ',')
      filter2.join_with(@filter.to_param).should == "mcf:exits<1000,mcf:pageviews>1000"
    end
  end

  context "a Filter instance" do
    before :each do
      @filter = Legato::Filter.new(query, :exits, :lt, 1000, nil)
    end

    it 'has a field' do
      @filter.field.should == :exits
    end

    it 'has a google field' do
      Legato.stubs(:to_ga_string).returns("ga:exits")
      @filter.google_field.should == "ga:exits"
      Legato.should have_received(:to_ga_string)
    end

    it 'has an operator' do
      @filter.operator.should == :lt
    end

    it 'has a google operator' do
      @filter.google_operator.should == "<"
    end

    it 'has a value' do
      @filter.value.should == 1000
    end

    it 'has a no default join character' do
      @filter.join_character.should == nil
    end

    it 'represents itself as a parameter' do
      @filter.to_param.should == "ga:exits<1000"
    end

    it 'joins with another filter' do
      filter2 = Legato::Filter.new(query, :pageviews, :gt, 1000, ',')

      filter2.join_with(@filter.to_param).should == "ga:exits<1000,ga:pageviews>1000"
    end

    it 'returns to_param if joining with nil' do
      @filter.join_with(nil).should == @filter.to_param
    end

    it 'properly escapes commas' do
      @filter.value = ","
      @filter.escaped_value.should == "\\,"
    end

    it 'properly escapes semicolons' do
      @filter.value = ";"
      @filter.escaped_value.should == "\\;"
    end
  end
end