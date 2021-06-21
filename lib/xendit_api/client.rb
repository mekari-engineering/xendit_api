require 'faraday_middleware'
require 'xendit_api/middleware/handle_response_exception'
require 'xendit_api/api/virtual_account'
require 'xendit_api/api/ewallet'
require 'xendit_api/api/credit_card'
require 'xendit_api/api/disbursement'

module XenditApi
  class Client
    BASE_URL = 'https://api.xendit.co'.freeze

    def initialize(authorization = nil)
      @connection = Faraday.new(url: BASE_URL) do |connection|
        connection.basic_auth(authorization, '')
        connection.request :json
        connection.response :json

        connection.use XenditApi::Middleware::HandleResponseException
        connection.adapter Faraday.default_adapter
      end
    end

    def ewallet
      @ewallet ||= XenditApi::Api::Ewallet.new(self)
    end

    def virtual_account
      @virtual_account ||= XenditApi::Api::VirtualAccount.new(self)
    end

    def credit_card
      @credit_card ||= XenditApi::Api::CreditCard.new(self)
    end

    def disbursement
      @disbursement ||= XenditApi::Api::Disbursement.new(self)
    end

    def get(url, params = nil)
      response = @connection.get(url, params)
      response.body
    end

    def post(url, params)
      response = @connection.post(url, params)
      response.body
    end

    def patch(url, params)
      response = @connection.patch(url, params)
      response.body
    end
  end
end
