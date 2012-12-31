require 'spec_helper'

module TransactionSpec
  class MockModel
    include RedisModel::Model
  end
end

describe RedisModel::Transaction do
  it 'yields the block in a transaction' do
    Redis.current.should_receive(:multi).and_yield
    TransactionSpec::MockModel.transaction {}
  end
end
