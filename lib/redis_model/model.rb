module RedisModel
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

        include RedisModel::Attributes
        include RedisModel::Errors
        include RedisModel::Transaction
        include RedisModel::Persistence
      end
    end
  end
end
