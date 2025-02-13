require 'xendit_api/api/base'
require 'xendit_api/model/v2/account'

module XenditApi
  module Api
    module V2
      class Account < XenditApi::Api::Base
        PATH = '/v2/accounts'.freeze

        def create(params)
          response = client.post(PATH, params)

          XenditApi::Model::V2::Account.new(response)
        end

        def find(id)
          response = client.get(PATH + "/#{id}")

          XenditApi::Model::V2::Account.new(response)
        end
      end
    end
  end
end
