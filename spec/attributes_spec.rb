require 'spec_helper'

module AttributesSpec
  class MockModel
    include RedisModel::Model

    attribute :foo, String
  end
end

describe RedisModel::Attributes do
  let(:model) { AttributesSpec::MockModel.new }

  it 'defines attributes' do
    model.foo = :bar
    model.foo.should == :bar
  end

  it 'exposes the attributes defined on the model' do
    TestModel.attributes.should == { :id => Integer, :foo => String }
  end

  it 'assigns attributes' do
    model.assign_attributes(:foo => 'bar')
    model.foo.should eq 'bar'
  end
end
