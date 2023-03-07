require 'xendit_api/api/base'
require 'xendit_api/model/balance'

module XenditApi
  module Api
    class Balance < XenditApi::Api::Base
      PATH = '/balance'.freeze
      CASH = 'CASH'.freeze
      CURRENCY = 'IDR'.freeze

      def get(account_type = nil, currency = CURRENCY, headers = {})
        account_type = account_type.nil? ? CASH : account_type
        get_path = "#{PATH}?account_type=#{account_type}&currency=#{currency}"
        response = @client.get_response(get_path, nil, headers)
        XenditApi::Model::Balance.new(response.body.merge(payload: response.body.to_json, request_id: response.headers['request-id']))
      end
    end
  end
end
