module Modis
  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration.new
  end

  class Configuration < Struct.new(:key_namespace)
  end
end
