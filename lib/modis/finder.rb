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

        records_to_models(records).select { |model| model.class.ancestors.include?(self) }
      end

      def attributes_for(redis, id)
        raise RecordNotFound, "Couldn't find #{name} without an ID" if id.nil?

        attributes = deserialize(record_for(redis, id))

        unless attributes['id'].present?
          raise RecordNotFound, "Couldn't find #{name} with id=#{id}"
        end

        attributes
      end

      def find_all(ids)
        raise RecordNotFound, "Couldn't find #{name} without an ID" if ids.empty?

        records = Modis.with_connection do |redis|
          blk = proc { |id| record_for(redis, id) }
          ids.count == 1 ? ids.map(&blk) : redis.pipelined { ids.map(&blk) }
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
        records.map do |record|
          model_for(deserialize(record)) unless record.blank?
        end.compact
      end

      def model_for(attributes)
        cls = model_class(attributes)
        return unless self == cls || cls < self
        cls.new(attributes, new_record: false)
      end

      def record_for(redis, id)
        key = sti_child? ? sti_base_key_for(id) : key_for(id)
        redis.hgetall(key)
      end

      def model_class(record)
        return self if record["type"].blank?
        record["type"].constantize
      end
    end
  end
end
