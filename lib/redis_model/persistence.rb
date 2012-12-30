module RedisModel
  module Persistence
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def key_namespace
        return @key_namespace if @key_namespace
        parts = name.split('::').map(&:underscore)
        parts.unshift(RedisModel.config.key_namespace)
        @key_namespace = parts.compact.join(':')
      end
    end

    def key_namespace
      self.class.key_namespace
    end

    def persisted?
      true
    end

    def key
      new_record? ? nil : "#{key_namespace}:#{id}"
    end

    def new_record?
      defined?(@new_record) ? @new_record : true
    end

    def create(attrs)
      run_callbacks :create do
        assign_attributes(attrs)
        save
      end
    end

    def create!(attrs)
      raise RecordNotSaved unless create(attrs)
    end

    def save
      set_id if new_record?
      self.class.transaction do
        callback = new_record? ? :update : :create
        run_callbacks callback do
          retval = Redis.current.hmset(key, *attributes.to_a.flatten)
          @new_record = false
          true # TODO
        end
      end
    end

    def save!
      raise RecordNotSaved unless save
    end

    def destroy
      run_callbacks :destroy do
      end
    end

    protected

    def set_id
      self.id = Redis.current.incr("#{key_namespace}_id")
    end
  end
end
