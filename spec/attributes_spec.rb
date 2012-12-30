require 'spec_helper'

describe RedisModel::Attributes do
  class TestModel
    include RedisModel

    attribute :foo, String
  end

  let(:model) { TestModel.new }

  it 'defines attributes' do
    model.foo = :bar
    model.foo.should == :bar
  end

  it 'exposes the attributes defined on the model' do
    TestModel.attributes.should == { :foo => String }
  end
end
