module RedisModel
  module Attributes
    def self.included(base)
      base.extend ClassMethods

      base.instance_eval do
        class << self
          attr_accessor :attributes
        end

        self.attributes = {}
      end
    end

    module ClassMethods
      def attribute(name, type = String)
        attributes[name] = type
        attr_accessor name
      end
    end

    def attributes
      @attributes ||= Hash[self.class.attributes.keys.zip]
    end
  end
end
