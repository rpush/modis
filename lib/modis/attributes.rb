module Modis
  module Attributes
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
        attributes[name] = type
        define_attribute_methods [name]
        class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            attributes[:#{name}]
          end

          def #{name}=(value)
            #{name}_will_change!
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
  end
end
