module Modis
  module Attribute
    TYPES = { :string => [String],
              :integer => [Fixnum],
              :float => [Float],
              :timestamp => [Time],
              :hash => [Hash],
              :array => [Array],
              :boolean => [TrueClass, FalseClass]}.freeze

    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        bootstrap_attributes
      end
    end

    module ClassMethods
      def bootstrap_attributes
        attr_reader :attributes

        class << self
          attr_accessor :attributes
        end

        self.attributes = {}

        attribute :id, :integer
      end

      def attribute(name, type, options = {})
        name = name.to_s
        raise AttributeError, "Attribute with name '#{name}' has already been specified." if attributes.key?(name)

        type_classes = Array(type).map do |t|
          raise UnsupportedAttributeType, t unless TYPES.key?(t)
          TYPES[t]
        end.flatten

        attributes[name] = options.update(type: type)
        define_attribute_methods [name]

        type_check = ''

        if type == :timestamp
          type_check += <<-RUBY
            value = Time.new(*value) if value && value.is_a?(Array) && value.count == 7
          RUBY
        end

        predicate = type_classes.map { |cls| "value.is_a?(#{cls.name})" }.join(' || ')
        type_check += <<-RUBY
        if value && !(#{predicate})
          raise Modis::AttributeCoercionError, "Received value of type '\#{value.class}', expected '#{type_classes.join("', '")}' for attribute '#{name}'."
        end
        RUBY

        class_eval <<-RUBY, __FILE__, __LINE__
          def #{name}
            attributes['#{name}']
          end

          def #{name}=(value)
            #{type_check}
            #{name}_will_change! if value != attributes['#{name}']
            attributes['#{name}'] = value
          end
        RUBY
      end
    end

    def assign_attributes(hash)
      hash.each do |k, v|
        setter = "#{k}="
        send(setter, v) if respond_to?(setter)
      end
    end

    def write_attribute(key, value)
      attributes[key.to_s] = value
    end

    def read_attribute(key)
      attributes[key.to_s]
    end

    protected

    def set_sti_type
      return unless self.class.sti_child?
      write_attribute(:type, self.class.name)
    end

    def reset_changes
      @changed_attributes = nil
    end

    def apply_defaults
      self.class.attributes.each do |attribute, options|
        write_attribute(attribute, options[:default]) if options[:default]
      end
    end
  end
end
