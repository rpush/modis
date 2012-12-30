module RedisModel
  module Errors
    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end
end
