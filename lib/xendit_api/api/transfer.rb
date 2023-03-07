require 'xendit_api/api/base'
require 'xendit_api/model/transfer'

module XenditApi
  module Api
    class Transfer < XenditApi::Api::Base
      PATH = '/transfers'.freeze

      def create(params)
        response = client.post_response(PATH, params)
        XenditApi::Model::Transfer.new(response.body.merge(request_id: response.headers['request-id']))
      end
    end
  end
end
