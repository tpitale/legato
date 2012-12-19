require 'spec_helper'

describe Legato do
  context 'to_ga_string' do
    it 'converts a string to google syntax' do
      Legato.to_ga_string("whatever").should == "ga:whatever"
      Legato.to_ga_string("whatever", "mcf").should == "mcf:whatever"
    end
  end

  context 'from_ga_string' do
    it 'converts a string google syntax' do
      Legato.from_ga_string("ga:whatever").should == "whatever"
      Legato.from_ga_string("mcf:whatever").should == "whatever"
    end
  end
end