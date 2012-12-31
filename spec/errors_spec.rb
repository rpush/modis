require 'spec_helper'

describe Modis::Errors do
  class TestModel
    include Modis::Model

    attribute :foo, String
  end

  let(:model) { TestModel.new }

  it 'adds errors' do
    model.errors.add(:foo, 'is not valid')
    model.errors[:foo].should eq ['is not valid']
  end
end
