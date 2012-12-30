module RedisModel
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
        class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            attributes[:#{name}]
          end

          def #{name}=(value)
            attributes[:#{name}] = value
          end
        EOS
      end
    end

    def attributes
      @attributes ||= Hash[self.class.attributes.keys.zip]
    end

    def assign_attributes(hash)
      attributes.update(hash)
    end
  end
end
