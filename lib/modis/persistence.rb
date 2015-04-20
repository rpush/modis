module Modis
  module Persistence
    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        class << self
          attr_reader :sti_child
          alias_method :sti_child?, :sti_child
        end
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

          @sti_child = true
          @sti_parent = parent

          bootstrap_attributes(parent)
          bootstrap_indexes(parent)
        end
      end

      def namespace
        return sti_parent.namespace if sti_child?
        @namespace ||= name.split('::').map(&:underscore).join(':')
      end

      def namespace=(value)
        @namespace = value
        @absolute_namespace = nil
      end

      def absolute_namespace
        @absolute_namespace ||= [Modis.config.namespace, namespace].compact.join(':')
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
      def deserialize(record)
        values = record.values
        values = MessagePack.unpack(msgpack_array_header(values.size) + values.join)
        keys = record.keys
        values.each_with_index { |v, i| record[keys[i]] = v }
        record
      rescue MessagePack::MalformedFormatError
        found_yaml = false

        record.each do |k, v|
          if v.start_with?(YAML_MARKER)
            found_yaml = true
            record[k] = YAML.load(v)
          else
            record[k] = MessagePack.unpack(v)
          end
        end

        if found_yaml
          id = record['id']
          STDERR.puts "#{self}(id: #{id}) contains attributes serialized as YAML. As of Modis 1.4.0, YAML is no longer used as the serialization format. To improve performance loading this record, you can force the record to new serialization format (MessagePack) with: #{self}.find(#{id}).save!(yaml_sucks: true)"
        end

        record
      end

      private

      def msgpack_array_header(n)
        if n < 16
          [0x90 | n].pack("C")
        elsif n < 65536
          [0xDC, n].pack("Cn")
        else
          [0xDD, n].pack("CN")
        end.force_encoding(Encoding::UTF_8)
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
          redis.pipelined do
            remove_from_indexes(redis)
            redis.srem(self.class.key_for(:all), id)
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

    def create_or_update(args = {})
      validate(args)
      future = persist(args[:yaml_sucks])

      if future && (future == :unchanged || future.value == 'OK')
        reset_changes
        @new_record = false
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

    def persist(persist_all)
      future = nil
      set_id if new_record?
      callback = new_record? ? :create : :update

      self.class.transaction do |redis|
        run_callbacks :save do
          run_callbacks callback do
            redis.pipelined do
              attrs = coerced_attributes(persist_all)
              future = attrs.any? ? redis.hmset(self.class.key_for(id), attrs) : :unchanged

              if new_record?
                redis.sadd(self.class.key_for(:all), id)
                add_to_indexes(redis)
              else
                update_indexes(redis)
              end
            end
          end
        end
      end

      future
    end

    def coerced_attributes(persist_all) # rubocop:disable Metrics/AbcSize
      attrs = []

      if new_record? || persist_all
        attributes.each do |k, v|
          if (self.class.attributes[k].try(:'[]', :default) || nil) != v
            attrs << k << coerce_for_persistence(v)
          end
        end
      else
        changed_attributes.each do |k, _|
          attrs << k << coerce_for_persistence(attributes[k])
        end
      end

      attrs
    end

    def set_id
      Modis.with_connection do |redis|
        self.id = redis.incr("#{self.class.absolute_namespace}_id_seq")
      end
    end
  end
end
