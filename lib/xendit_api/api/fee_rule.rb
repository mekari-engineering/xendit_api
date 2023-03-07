require 'xendit_api/api/base'
require 'xendit_api/model/fee_rule'

module XenditApi
  module Api
    class FeeRule < XenditApi::Api::Base
      PATH = '/fee_rules'.freeze

      def create(params)
        response = client.post_response(PATH, params)
        XenditApi::Model::FeeRule.new(response.body.merge(request_id: response.headers['request-id']))
      end
    end
  end
end
