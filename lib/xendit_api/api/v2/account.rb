require 'xendit_api/api/base'
require 'xendit_api/model/v2/account'

module XenditApi
  module Api
    module V2
      class Account < XenditApi::Api::Base
        PATH = '/v2/accounts'.freeze

        def post(params:)
          response = client.post(PATH, params)

          XenditApi::Model::V2::Account.new(response)
        end
      end
    end
  end
end
