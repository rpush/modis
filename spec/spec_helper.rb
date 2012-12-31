begin
  require './spec/support/simplecov_helper'
  include SimpleCovHelper
  start_simple_cov('unit')
rescue LoadError
  puts "Coverage disabled."
end

require 'modis'

Modis.configure do |config|
  config.key_namespace = 'modis'
end

RSpec.configure do |config|
  config.before :each do
    keys = Redis.current.keys "#{Modis.config.key_namespace}:*"
    Redis.current.del *keys unless keys.empty?
  end
end
