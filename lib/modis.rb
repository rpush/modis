# frozen_string_literal: true

require 'redis'
require 'connection_pool'
require 'active_model'
require 'active_support/all'
require 'msgpack'

require 'modis/version'
require 'modis/configuration'
require 'modis/attribute'
require 'modis/errors'
require 'modis/persistence'
require 'modis/transaction'
require 'modis/finder'
require 'modis/index'
require 'modis/model'

module Modis
  @mutex = Mutex.new
  class << self
    attr_writer :connection_pool_size, :connection_pool_timeout,
                :connection_pools

    def redis_options
      @redis_options ||= { default: {} }
    end

    def redis_options=(options)
      if options.is_a?(Hash) && options.values.first.is_a?(Hash)
        @redis_options = options.transform_values(&:dup)
      else
        @redis_options[:default] = options
      end
    end

    def connection_pool_size
      @connection_pool_size ||= 5
    end

    def connection_pool_timeout
      @connection_pool_timeout ||= 5
    end

    def connection_pools
      @connection_pools ||= {}
    end

    def connection_pool(pool_name = :default)
      connection_pools[pool_name] ||= begin
        @mutex.synchronize do
          ConnectionPool.new(
            size: connection_pool_size,
            timeout: connection_pool_timeout
          ) do
            Redis.new(redis_options[pool_name])
          end
        end
      end
    end

    def with_connection(pool_name = :default)
      connection_pool(pool_name).with { |connection| yield(connection) }
    end
  end
end
