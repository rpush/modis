module Modis
  module Finder
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def find(*ids)
        models = find_all(ids)
        ids.count == 1 ? models.first : models
      end

      def all
        records = Modis.with_connection do |redis|
          ids = redis.smembers(key_for(:all))
          redis.pipelined do
            ids.map { |id| record_for(redis, id) }
          end
        end

        records_to_models(records)
      end

      def attributes_for(redis, id)
        raise RecordNotFound, "Couldn't find #{name} without an ID" if id.nil?

        attributes = record_to_attributes(record_for(redis, id))

        unless attributes['id'].present?
          raise RecordNotFound, "Couldn't find #{name} with id=#{id}"
        end

        attributes
      end

      def find_all(ids)
        raise RecordNotFound, "Couldn't find #{name} without an ID" if ids.empty?

        records = Modis.with_connection do |redis|
          redis.pipelined do
            ids.map { |id| record_for(redis, id) }
          end
        end

        models = records_to_models(records)

        if models.count < ids.count
          missing = ids - models.map(&:id)
          raise RecordNotFound, "Couldn't find #{name} with id=#{missing.first}"
        end

        models
      end

      private

      def records_to_models(records)
        models = []

        records.each do |record|
          unless record.blank?
            attributes = record_to_attributes(record)
            models << model_for(attributes)
          end
        end

        models
      end

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
