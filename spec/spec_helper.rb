begin
  require './spec/support/simplecov_helper'
  include SimpleCovHelper
  start_simple_cov('unit')
rescue LoadError
  puts "Coverage disabled."
end

require 'redis_model'

RedisModel.configure do |config|
  config.key_namespace = 'redis_model'
end

RSpec.configure do |config|
  config.before :each do
    keys = Redis.current.keys "#{RedisModel.config.key_namespace}:*"
    Redis.current.del *keys unless keys.empty?
  end
end
