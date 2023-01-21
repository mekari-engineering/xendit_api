require 'xendit_api/api/base'
require 'xendit_api/model/fee_rule'

module XenditApi
  module Api
    class FeeRule < XenditApi::Api::Base
      PATH = '/fee_rules'.freeze

      def create(params)
        response = client.post(PATH, params)
        XenditApi::Model::FeeRule.new(response)
      end
    end
  end
end
