module RedisModel
  module Persistence
    def create
      run_callbacks :create do
      end
    end

    def save
      run_callbacks :save do
      end
    end

    def destroy
      run_callbacks :destroy do
      end
    end
  end
end
