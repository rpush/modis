module RedisModel
  module Transaction
    def self.included(base)
      base.extend ClassMethods
    end

    # TODO: Not thread safe. How does Redis-rb handle connections?
    module ClassMethods
      def transaction
        Redis.current.multi
        begin
          yield
        rescue Exception
          Redis.current.discard
          raise
        else
          Redis.current.exec
        end
      end
    end
  end
end
