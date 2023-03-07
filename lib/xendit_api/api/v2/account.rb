require 'xendit_api/api/base'
require 'xendit_api/model/v2/account'

module XenditApi
  module Api
    module V2
      class Account < XenditApi::Api::Base
        PATH = '/v2/accounts'.freeze

        def create(params)
          response = client.post_response(PATH, params)

          XenditApi::Model::V2::Account.new(response.body.merge(request_id: response.headers['request-id']))
        end
      end
    end
  end
end
