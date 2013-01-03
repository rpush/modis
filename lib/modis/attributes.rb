module Modis
  module Attributes
    TYPES = [:string, :integer, :float, :time, :boolean]

    def self.included(base)
      base.extend ClassMethods

      base.instance_eval do
        class << self
          attr_accessor :attributes
        end

        self.attributes = {}

        attribute :id, :integer
      end
    end

    module ClassMethods
      def attribute(name, type = :string, options = {})
        raise UnsupportedAttributeType.new(type) unless TYPES.include?(type)

        attributes[name] = options.update({ :type => type })
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
      hash.each { |k, v| send("#{k}=", v) }
    end

    protected

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

    def coerce_value(value, attribute)
      return if value.nil?
      type = self.class.attributes[attribute][:type]

      if type == :string
        value.to_s
      elsif type == :integer
        value.to_i
      elsif type == :float
        value.to_f
      elsif type == :time
        return value if value.kind_of?(Time)
        Time.parse(value)
      elsif :boolean
        return true if value == 'true'
        return false if value == 'false'
        # TODO: raise!
      else
        value
      end
    end
  end
end
