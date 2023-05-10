require 'spec_helper'

describe Legato::Core::V3::Request do
  context "with the scope set" do
    let(:klass) { Class.new.tap { |k| k.extend(Legato::Model)} }
    let(:query) { Legato::Core::Query.new(klass) }
    let(:request) { Legato::Core::V3::Request.new(nil, query) }

    it 'raises when an invalid scope is passed in' do
      query.tracking_scope = "what"
      expect { request.base_url }.to raise_error
    end

    it 'sets the correct endpoint url' do
      query.tracking_scope = "mcf"
      expect(request.base_url).to eql("https://www.googleapis.com/analytics/v3/data/mcf")
    end

    it 'has the correct api endpoint' do
      query.tracking_scope = "ga"
      expect(request.base_url).to eql("https://www.googleapis.com/analytics/v3/data/ga")
    end

    it 'has the realtime api endpoint' do
      query.tracking_scope = "rt"
      expect(request.base_url).to eql("https://www.googleapis.com/analytics/v3/data/realtime")
    end
  end
end
