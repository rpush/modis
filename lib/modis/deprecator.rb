# frozen_string_literal: true

module Modis
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('5.0', 'modis')
  end
end
