module Modis
  module Attribute
    TYPES = { String => :string,
              Fixnum => :integer,
              Float => :float,
              Time => :timestamp,
              Hash => :hash,
              Array => :array,
              TrueClass => :boolean,
              FalseClass => :boolean }.freeze

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
        Array(type).each { |t| raise UnsupportedAttributeType, t unless TYPES.values.include?(t) }
        attributes[name] = options.update(type: type)
        define_attribute_methods [name]

        class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            attributes['#{name}']
          end

          def #{name}=(value)
            if value != attributes['#{name}']
              ensure_type('#{name}', value)
              #{name}_will_change!
            end

            attributes['#{name}'] = value
          end
        EOS
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
