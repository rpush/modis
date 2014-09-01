module Modis
  module Attribute
    TYPES = [:string, :integer, :float, :timestamp, :boolean, :array, :hash]

    def self.included(base)
      base.extend ClassMethods
      base.instance_eval do
        bootstrap_attributes
      end
    end

    module ClassMethods
      def bootstrap_attributes
        class << self
          attr_accessor :attributes
        end

        self.attributes = {}

        attribute :id, :integer
      end

      def attribute(name, types, options = {})
        name = name.to_s
        types = Array[*types]
        raise AttributeError, "Attribute with name '#{name}' has already been specified." if attributes.key?(name)
        types.each { |type| raise UnsupportedAttributeType, type unless TYPES.include?(type) }

        attributes[name] = options.update(types: types)
        define_attribute_methods [name]
        class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            attributes['#{name}']
          end

          def #{name}=(value)
            ensure_type('#{name}', value)
            #{name}_will_change! unless value == attributes['#{name}']
            attributes['#{name}'] = value
          end
        EOS
      end
    end

    def attributes
      @attributes ||= Hash[self.class.attributes.keys.zip]
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
      assign_attributes(type: self.class.name)
    end

    def reset_changes
      @changed_attributes.clear if @changed_attributes
    end

    def apply_defaults
      defaults = {}
      self.class.attributes.each do |attribute, options|
        defaults[attribute] = options[:default] if options[:default]
      end
      assign_attributes(defaults)
    end
  end
end
