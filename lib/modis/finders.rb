module Modis
  module Finders
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def find(id)
        values = Redis.current.hgetall(key_for(id))
        unless values['id'].present?
          raise RecordNotFound, "Couldn't find #{name} with id=#{id}"
        end
        model = new
        model.attributes.update(values.symbolize_keys)
        model
      end
    end
  end
end
