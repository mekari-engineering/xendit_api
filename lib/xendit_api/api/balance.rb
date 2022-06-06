require 'xendit_api/api/base'
require 'xendit_api/model/balance'

module XenditApi
  module Api
    class Balance < XenditApi::Api::Base
      PATH = '/balance'.freeze

      def get(account_type = nil)
        get_path = account_type.nil? ? PATH : "#{PATH}?account_type=#{account_type}"
        response = @client.get(get_path)
        XenditApi::Model::Balance.new(response.merge(payload: response.to_json))
      end
    end
  end
end
