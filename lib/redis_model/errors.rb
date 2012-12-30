module RedisModel
  class RedisModelError < StandardError; end
  class RecordNotSaved < RedisModelError; end

  module Errors
    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end
end
