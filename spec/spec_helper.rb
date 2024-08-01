# frozen_string_literal: true

unless ENV['CI']
  begin
    require './spec/support/simplecov_helper'
    include SimpleCovHelper # rubocop:disable Style/MixinUsage
    start_simple_cov('unit')
  rescue LoadError
    puts "Coverage disabled."
  end
end

require 'modis'

Redis.raise_deprecations = true if Gem.loaded_specs['redis'].version >= Gem::Version.new('4.6.0')

RSpec.configure do |config|
  config.after :each do
    RSpec::Mocks.space.proxy_for(Modis).reset
    Modis.reset!
    Modis.configure do |modis_config|
      modis_config.namespace = 'modis'
    end
  end
end
