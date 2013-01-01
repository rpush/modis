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

        extend ClassMethods

        include Modis::Errors
        include Modis::Attributes
        include Modis::Transaction
        include Modis::Persistence
        include Modis::Finders
      end
    end

    module ClassMethods
      def instantiate(record, options={})
        model = new
        model.assign_attributes(record.symbolize_keys)
        model.reset_changes
         if options.key?(:new_record)
          model.instance_variable_set('@new_record', options[:new_record])
        end
        model
      end
    end

    def ==(other)
      super || other.instance_of?(self.class) && id.present? && other.id == id
    end
    alias :eql? :==
  end
end
