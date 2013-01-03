module Modis
  module Finders
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def find(id)
        values = Redis.current.hgetall(key_for(id))
        unless values['id'].present?
          raise RecordNotFound, "Couldn't find #{name} with id=#{id}"
        end
        new(values, :new_record => false)
      end

      def all
        ids = Redis.current.smembers(key_for(:all))
        records = Redis.current.pipelined do
          ids.map { |id| Redis.current.hgetall(key_for(id)) }
        end
        records.map { |record| new(record, :new_record => false) }
      end
    end
  end
end
