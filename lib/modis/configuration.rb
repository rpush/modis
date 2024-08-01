# frozen_string_literal: true

module Modis
  def self.configure
    yield config
  end

  class Configuration < Struct.new(:namespace)
  end

  class << self
    def config
      @config ||= Configuration.new
    end
  end
end
