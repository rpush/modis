require 'spec_helper'

describe RedisModel::Persistence do
  module TestModule
    class TestModel
      include RedisModel::Model
    end
  end

  let(:model) { TestModule::TestModel.new }

  it 'returns a key namesapce' do
    TestModule::TestModel.key_namespace.should == 'redis_model:test_module:test_model'
    model.key_namespace.should == 'redis_model:test_module:test_model'
  end

  it 'returns a key' do
    model.save!
    model.key.should eq 'redis_model:test_module:test_model:1'
  end

  it 'returns a nil key if not saved' do
    model.key.should be_nil
  end

  # describe 'create' do
  # end

  # describe 'create' do
  # end
end
