module Modis
  module Attributes
    TYPES = [String, Integer, Float, Time]

    def self.included(base)
      base.extend ClassMethods

      base.instance_eval do
        class << self
          attr_accessor :attributes
        end

        self.attributes = {}

        attribute :id, Integer
      end
    end

    module ClassMethods
      def attribute(name, type = String)
        raise UnsupportedAttributeType.new(type.name) unless TYPES.include?(type)

        attributes[name] = type
        define_attribute_methods [name]
        class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            attributes[:#{name}]
          end

          def #{name}=(value)
            value = coerce_value(value, :#{name})
            #{name}_will_change! unless value == attributes[:#{name}]
            attributes[:#{name}] = value
          end
        EOS
      end
    end

    def attributes
      @attributes ||= Hash[self.class.attributes.keys.zip]
    end

    def assign_attributes(hash)
      hash.each { |k, v| send("#{k}=", v)}
    end

    def reset_changes
      @changed_attributes.clear
    end

    protected

    def coerce_value(value, attribute)
      return if value.nil?
      type = self.class.attributes[attribute]

      if type == String
        value.to_s
      elsif type == Integer
        value.to_i
      elsif type == Float
        value.to_f
      elsif type == Time
        return value if value.kind_of?(Time)
        Time.parse(value)
      else
        value
      end
    end
  end
end
