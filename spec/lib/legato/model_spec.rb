require 'spec_helper'

describe "Legato::Model" do
  def model_class
    Class.new.tap do |model|
      model.extend(Legato::model)
    end
  end

  before :each do
    @model = model_class.new
  end

  # it 'has a metric' do
  #   @model.metrics :exits
  # end

  # it 'has metrics' do
  #   @model.metrics :exits, :pageviews
  # end

  # xit 'has dimensions'
  # xit 'has filters'
  # xit 'has an instance klass'
  # xit 'sets an instance klass'
  # xit 'has results'
end
