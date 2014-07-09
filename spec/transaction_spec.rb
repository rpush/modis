require 'spec_helper'

module TransactionSpec
  class MockModel
    include Modis::Model
  end
end

describe Modis::Transaction do
  it 'yields the block in a transaction' do
    redis = double.as_null_object
    Modis.stub(:with_connection).and_yield(redis)
    redis.should_receive(:multi)
    TransactionSpec::MockModel.transaction {}
  end
end
