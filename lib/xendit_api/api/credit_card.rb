require 'xendit_api/client'
require 'xendit_api/api/base'
require 'xendit_api/model/credit_card'

module XenditApi
  module Api
    class CreditCard < XenditApi::Api::Base
      PATH = '/credit_card_charges'.freeze

      def charge(params)
        response = client.post(PATH, params)
        XenditApi::Model::CreditCard.new(response)
      end

      def find(id)
        find_path = "#{PATH}/#{id}"
        response = client.get(find_path, {})
        XenditApi::Model::CreditCard.new(response)
      end
    end
  end
end
