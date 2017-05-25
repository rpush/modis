# frozen_string_literal: true

module Modis
  module Transaction
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def transaction
        Modis.with_connection { |redis| redis.multi { yield(redis) } }
      end
    end
  end
end
