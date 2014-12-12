module Modis
  module Model
    def self.included(base)
      base.instance_eval do
        include ActiveModel::Dirty
        include ActiveModel::Validations
        include ActiveModel::Serialization

        extend ActiveModel::Naming
        extend ActiveModel::Callbacks

        define_model_callbacks :save, :create, :update, :destroy
        define_model_callbacks :_internal_create, :_internal_update, :_internal_destroy

        include Modis::Errors
        include Modis::Transaction
        include Modis::Persistence
        include Modis::Finder
        include Modis::Attribute
        include Modis::Index

        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def inherited(child)
        super
        bootstrap_sti(self, child)
      end
    end

    def initialize(record = nil, options = {})
      @attributes = {}
      set_sti_type
      apply_defaults
      assign_attributes(record.symbolize_keys) if record
      reset_changes

      return unless options.key?(:new_record)
      instance_variable_set('@new_record', options[:new_record])
    end

    def ==(other)
      super || other.instance_of?(self.class) && id.present? && other.id == id
    end
    alias_method :eql?, :==
  end
end
