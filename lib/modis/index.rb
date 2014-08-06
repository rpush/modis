module Modis
  module Index
    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        bootstrap_indexes
        after__internal_create :add_to_index
        after__internal_update :update_index
        before__internal_destroy :remove_from_index
      end
    end

    module ClassMethods
      def bootstrap_indexes
        class << self
          attr_accessor :indexed_attributes
        end

        self.indexed_attributes = []
      end

      def index(attribute)
        attribute = attribute.to_s
        raise IndexError, "No such attribute '#{attribute}'" unless attributes.key?(attribute)
        indexed_attributes << attribute
      end

      def where(query)
        raise IndexError, 'Queries using multiple indexes is not currently supported.' if query.keys.size > 1
        attribute, value = query.first
        index = index_for(attribute, value)
        index.map { |id| find(id) }
      end

      def index_for(attribute, value)
        Modis.with_connection do |redis|
          key = index_key(attribute, value)
          redis.smembers(key).map(&:to_i)
        end
      end

      def index_key(attribute, value)
        "#{absolute_namespace}:index:#{attribute}:#{value.inspect}"
      end
    end

    private

    def indexed_attributes
      self.class.indexed_attributes
    end

    def index_key(attribute, value)
      self.class.index_key(attribute, value)
    end

    def add_to_index
      return if indexed_attributes.empty?

      Modis.with_connection do |redis|
        indexed_attributes.each do |attribute|
          key = index_key(attribute, read_attribute(attribute))
          redis.sadd(key, id)
        end
      end
    end

    def remove_from_index
      return if indexed_attributes.empty?

      Modis.with_connection do |redis|
        indexed_attributes.each do |attribute|
          key = index_key(attribute, read_attribute(attribute))
          redis.srem(key, id)
        end
      end
    end

    def update_index
      return if indexed_attributes.empty?

      Modis.with_connection do |redis|
        (changes.keys & indexed_attributes).each do |attribute|
          old_value, new_value = changes[attribute]
          old_key = index_key(attribute, old_value)
          new_key = index_key(attribute, new_value)
          redis.smove(old_key, new_key, id)
        end
      end
    end
  end
end
