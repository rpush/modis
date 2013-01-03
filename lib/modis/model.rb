module Modis
  module Model
    def self.included(base)
      base.instance_eval do
        include ActiveModel::Dirty
        include ActiveModel::Validations
        include ActiveModel::Serialization

        extend ActiveModel::Naming
        extend ActiveModel::Callbacks

        define_model_callbacks :create
        define_model_callbacks :update
        define_model_callbacks :destroy

        include Modis::Errors
        include Modis::Attributes
        include Modis::Transaction
        include Modis::Persistence
        include Modis::Finders
      end
    end

    def initialize(record=nil, options={})
      assign_attributes(record.symbolize_keys) if record
      apply_defaults
      reset_changes
       if options.key?(:new_record)
        instance_variable_set('@new_record', options[:new_record])
      end
    end

    def ==(other)
      super || other.instance_of?(self.class) && id.present? && other.id == id
    end
    alias :eql? :==
  end
end
