require 'redis'
require 'connection_pool'
require 'active_model'
require 'active_support/all'
require 'multi_json'

require 'modis/version'
require 'modis/configuration'
require 'modis/attributes'
require 'modis/errors'
require 'modis/persistence'
require 'modis/transaction'
require 'modis/finders'
require 'modis/model'

module Modis
  @mutex = Mutex.new

  class << self
    attr_accessor :connection_pool, :redis_options, :connection_pool_size,
      :connection_pool_timeout
  end

  self.redis_options = {}
  self.connection_pool_size = 5
  self.connection_pool_timeout = 5

  def self.connection_pool
    return @connection_pool if @connection_pool
    @mutex.synchronize do
      options = { size: connection_pool_size, timeout: connection_pool_timeout }
      @connection_pool = ConnectionPool.new(options) { Redis.new(redis_options) }
    end
  end

  def self.with_connection
    connection_pool.with { |connection| yield(connection) }
  end
end
