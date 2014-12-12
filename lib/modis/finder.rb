module Modis
  module Finder
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def find(id)
        Modis.with_connection do |redis|
          attributes = attributes_for(redis, id)
          model_for(attributes)
        end
      end

      def all
        records = []

        Modis.with_connection do |redis|
          ids = redis.smembers(key_for(:all))
          records = redis.pipelined do
            ids.map { |id| record_for(redis, id) }
          end
        end

        records.map do |record|
          attributes = record_to_attributes(record)
          model_for(attributes)
        end
      end

      def attributes_for(redis, id)
        raise RecordNotFound, "Couldn't find #{name} without an ID" if id.nil?

        attributes = record_to_attributes(record_for(redis, id))

        unless attributes['id'].present?
          raise RecordNotFound, "Couldn't find #{name} with id=#{id}"
        end

        attributes
      end

      private

      def model_for(attributes)
        model_class(attributes).new(attributes, new_record: false)
      end

      def record_to_attributes(record)
        record.each { |k, v| record[k] = coerce_from_persistence(k, v) }
        record
      end

      def record_for(redis, id)
        redis.hgetall(key_for(id))
      end

      def model_class(record)
        return self if record["type"].blank?
        record["type"].constantize
      end
    end
  end
end
