module Modis
  module Persistence
    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        after__internal_create :track
        before__internal_destroy :untrack
      end
    end

    module ClassMethods
      # :nodoc:
      def bootstrap_sti(parent, child)
        child.instance_eval do
          parent.instance_eval do
            class << self
              attr_accessor :sti_parent
            end
            attribute :type, :string unless attributes.key?('type')
          end

          class << self
            delegate :attributes, :indexed_attributes, to: :sti_parent
          end

          @sti_child = true
          @sti_parent = parent
        end
      end

      # :nodoc:
      def sti_child?
        @sti_child == true
      end

      def namespace
        return sti_parent.namespace if sti_child?
        return @namespace if @namespace
        @namespace = name.split('::').map(&:underscore).join(':')
      end

      attr_writer :namespace

      def absolute_namespace
        parts = [Modis.config.namespace, namespace]
        @absolute_namespace = parts.compact.join(':')
      end

      def key_for(id)
        "#{absolute_namespace}:#{id}"
      end

      def create(attrs)
        model = new(attrs)
        model.save
        model
      end

      def create!(attrs)
        model = new(attrs)
        model.save!
        model
      end

      YAML_MARKER = '---'.freeze
      def coerce_from_persistence(attribute, value)
        # Modis < 1.4.0 used YAML for serialization.
        return YAML.load(value) if value.start_with?(YAML_MARKER)

        value = MessagePack.unpack(value)
        value = Time.new(*value) if value && attributes[attribute.to_s][:type] == :timestamp
        value
      end
    end

    def persisted?
      true
    end

    def key
      new_record? ? nil : self.class.key_for(id)
    end

    def new_record?
      defined?(@new_record) ? @new_record : true
    end

    def save(args = {})
      create_or_update(args)
    rescue Modis::RecordInvalid
      false
    end

    def save!(args = {})
      create_or_update(args) || (raise RecordNotSaved)
    end

    def destroy
      self.class.transaction do |redis|
        run_callbacks :destroy do
          run_callbacks :_internal_destroy do
            redis.del(key)
          end
        end
      end
    end

    def reload
      new_attributes = Modis.with_connection { |redis| self.class.attributes_for(redis, id) }
      initialize(new_attributes)
      self
    end

    def update_attribute(name, value)
      assign_attributes(name => value)
      save(validate: false)
    end

    def update_attributes(attrs)
      assign_attributes(attrs)
      save
    end

    def update_attributes!(attrs)
      assign_attributes(attrs)
      save!
    end

    private

    def coerce_for_persistence(value)
      value = [value.year, value.month, value.day, value.hour, value.min, value.sec, value.strftime("%:z")] if value.is_a?(Time)
      MessagePack.pack(value)
    end

    def ensure_type(attribute, value)
      return unless value
      expected_type = self.class.attributes[attribute.to_s][:type]
      received_type = Modis::Attribute::TYPES[value.class]
      return if expected_type.is_a?(Array) ? expected_type.include?(received_type) : expected_type == received_type
      raise Modis::AttributeCoercionError, "Received value of type #{received_type.inspect}, expected #{Array(expected_type).map(&:inspect).join(', ')} for attribute '#{attribute}'."
    end

    def create_or_update(args = {})
      validate(args)
      future = persist

      if future && future.value == 'OK'
        reset_changes
        @new_record = false
        new_record? ? add_to_index : update_index
        true
      else
        false
      end
    end

    def validate(args)
      skip_validate = args.key?(:validate) && args[:validate] == false
      return if skip_validate || valid?
      raise Modis::RecordInvalid, errors.full_messages.join(', ')
    end

    def persist
      future = nil
      set_id if new_record?
      callback = new_record? ? :create : :update

      self.class.transaction do |redis|
        run_callbacks :save do
          run_callbacks callback do
            run_callbacks "_internal_#{callback}" do
              attrs = []
              attributes.each { |k, v| attrs << k << coerce_for_persistence(v) }
              future = redis.hmset(self.class.key_for(id), attrs)
            end
          end
        end
      end

      future
    end

    def set_id
      Modis.with_connection do |redis|
        self.id = redis.incr("#{self.class.absolute_namespace}_id_seq")
      end
    end

    def track
      Modis.with_connection { |redis| redis.sadd(self.class.key_for(:all), id) }
    end

    def untrack
      Modis.with_connection { |redis| redis.srem(self.class.key_for(:all), id) }
    end
  end
end
