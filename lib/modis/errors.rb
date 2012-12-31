module Modis
  class ModisError < StandardError; end
  class RecordNotSaved < ModisError; end

  module Errors
    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
  end
end
