module Modis
  module Finders
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def find(id)
        record = attributes_for(id)
        model_class(record).new(record, new_record: false)
      end

      def all
        records = []

        Modis.with_connection do |redis|
          ids = redis.smembers(key_for(:all))
          records = redis.pipelined do
            ids.map { |id| redis.hgetall(key_for(id)) }
          end
        end

        records.map do |record|
          klass = model_class(record)
          klass.new(record, new_record: false)
        end
      end

      def attributes_for(id)
        raise RecordNotFound, "Couldn't find #{name} without an ID" if id.nil?

        values = Modis.with_connection { |redis| redis.hgetall(key_for(id)) }
        unless values['id'].present?
          raise RecordNotFound, "Couldn't find #{name} with id=#{id}"
        end
        values
      end

      private

      def model_class(record)
        return self if record["type"].blank?
        record["type"].constantize
      end
    end
  end
end
