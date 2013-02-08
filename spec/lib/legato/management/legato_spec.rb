require 'spec_helper'

describe Legato do
  context 'to_ga_string' do
    it 'returns the correct dimesion with the ga namespace' do
      Legato.to_ga_string("dimension").should == "ga:dimension"
    end

    it 'returns the correct dimesion with the Multi-Channel Funnels namespace (mcf)' do
      Legato.to_ga_string("dimension", "mcf").should == "mcf:dimension"
    end
  end
end