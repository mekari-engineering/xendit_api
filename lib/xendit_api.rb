# frozen_string_literal: true

require_relative 'xendit_api/version'
require 'xendit_api/client'

# require errors
require 'xendit_api/errors'
require 'xendit_api/errors/ovo'
require 'xendit_api/errors/disbursement'
require 'xendit_api/errors/credit_card'
require 'xendit_api/errors/virtual_account'
require 'xendit_api/errors/v1/ewallet'

module XenditApi
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :logger
  end
end
