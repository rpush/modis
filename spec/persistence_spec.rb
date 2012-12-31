require 'spec_helper'

module PersistenceSpec
  class MockModel
    include RedisModel::Model
  end
end

describe RedisModel::Persistence do
  let(:model) { PersistenceSpec::MockModel.new }

  it 'returns a key namesapce' do
    PersistenceSpec::MockModel.key_namespace.should == 'redis_model:persistence_spec:mock_model'
    model.key_namespace.should == 'redis_model:persistence_spec:mock_model'
  end

  it 'returns a key' do
    model.save!
    model.key.should eq 'redis_model:persistence_spec:mock_model:1'
  end

  it 'returns a nil key if not saved' do
    model.key.should be_nil
  end

  # describe 'create' do
  # end

  # describe 'create' do
  # end
end
