require 'faraday_middleware'
require 'xendit_api/middleware/handle_response_exception'
require 'xendit_api/api/virtual_account'
require 'xendit_api/api/ewallet'
require 'xendit_api/api/credit_card'
require 'xendit_api/api/balance'
require 'xendit_api/api/disbursement'
require 'xendit_api/api/v1/ewallet'
require 'xendit_api/api/qr_code'
require 'xendit_api/api/v2/invoice'
require 'xendit_api/api/v2/account'
require 'xendit_api/api/transfer'
require 'xendit_api/api/transaction'
require 'xendit_api/api/fee_rule'
require 'xendit_api/api/report'
require 'logger'

module XenditApi
  # rubocop:disable Metrics/ClassLength
  class Client
    BASE_URL = 'https://api.xendit.co'.freeze

    def initialize(authorization = nil, options = {})
      @connection = Faraday.new(url: BASE_URL) do |connection|
        connection.request :basic_auth, authorization, ''
        connection.request :json
        connection.request :instrumentation, name: options[:instrumentation_name] if options[:instrumentation_name]
        connection.response :json
        connection.options.timeout = options[:timeout] if options.key?(:timeout)

        logger = find_logger(options[:logger])
        if logger
          connection.response :logger, logger, { headers: false, bodies: true, errors: true } do |log|
            filtered_logs = options[:filtered_logs]
            if filtered_logs.respond_to?(:each)
              filtered_logs.each do |filter|
                log.filter(%r{(#{filter}=)([\w+-.?@:/]+)}, '\1[FILTERED]')
                log.filter(/(#{filter}":\s*")(.*?)(")/i, '\1[FILTERED]\3')
                log.filter(/(#{filter}":\s*)(\d+(?:\.\d+)?|true|false)/i, '\1[FILTERED]')
                log.filter(/(#{filter}":\s*)(\[.*?\])/i, '\1[FILTERED]')
              end
            end
          end
        end
        connection.use XenditApi::Middleware::HandleResponseException, logger
        connection.adapter Faraday.default_adapter
      end
    end

    def ewallet
      @ewallet ||= XenditApi::Api::Ewallet.new(self)
    end

    def balance
      @balance ||= XenditApi::Api::Balance.new(self)
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

    def v1_ewallet
      @v1_ewallet ||= XenditApi::Api::V1::Ewallet.new(self)
    end

    def qr_code
      @qr_code ||= XenditApi::Api::QrCode.new(self)
    end

    def invoice
      @invoice ||= XenditApi::Api::V2::Invoice.new(self)
    end

    def account
      @account ||= XenditApi::Api::V2::Account.new(self)
    end

    def transfer
      @transfer || XenditApi::Api::Transfer.new(self)
    end

    def transaction
      @transaction || XenditApi::Api::Transaction.new(self)
    end

    def fee_rule
      @fee_rule || XenditApi::Api::FeeRule.new(self)
    end

    def report
      @report || XenditApi::Api::Report.new(self)
    end

    def get(url, params = nil, headers = {})
      response = @connection.get(url, params, headers)
      response.body
    end

    def get_response(url, params = nil, headers = {})
      @connection.get(url, params, headers)
    end

    def post(url, params, headers = {})
      response = @connection.post(url) do |req|
        req.headers = headers if headers
        req.body = params
      end
      response.body
    end

    def post_response(url, params, headers = {})
      @connection.post(url) do |req|
        req.headers = headers if headers
        req.body = params
      end
    end

    def patch(url, params, headers = {})
      response = @connection.patch(url) do |req|
        req.headers = headers if headers
        req.body = params
      end
      response.body
    end

    def patch_response(url, params, headers = {})
      @connection.patch(url) do |req|
        req.headers = headers if headers
        req.body = params
      end
    end

    def find_logger(logger_option)
      logger_option || XenditApi.configuration&.logger
    end
  end
  # rubocop:enable Metrics/ClassLength
end
