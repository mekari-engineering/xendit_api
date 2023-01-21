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
        response = @client.get(get_path, nil, headers)
        XenditApi::Model::Balance.new(response.merge(payload: response.to_json))
      end
    end
  end
end
