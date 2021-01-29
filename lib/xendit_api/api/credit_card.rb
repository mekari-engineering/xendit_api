require 'xendit_api/client'
require 'xendit_api/api/base'
require 'xendit_api/model/credit_card'
module XenditApi
  module Api
    class CreditCard < XenditApi::Api::Base
      PATH = '/credit_card_charges'.freeze

      def charge(params)
        response = client.post(PATH, params)
        credit_card_params = permitted_credit_card_params(response)
        XenditApi::Model::CreditCard.new(credit_card_params)
      end

      def find(id)
        find_path = "#{PATH}/#{id}"
        response = client.get(find_path, {})
        credit_card_params = permitted_credit_card_params(response)
        XenditApi::Model::CreditCard.new(credit_card_params)
      end

      private

      def permitted_credit_card_params(response = {})
        {
          id: response['id'],
          created: response['created'],
          business_id: response['business_id'],
          authorized_amount: response['authorized_amount'],
          approval_code: response['approval_code'],
          external_id: response['external_id'],
          merchant_id: response['merchant_id'],
          merchant_reference_code: response['merchant_reference_code'],
          masked_card_number: response['masked_card_number'],
          charge_type: response['charge_type'],
          card_brand: response['card_brand'],
          card_type: response['card_type'],
          descriptor: response['descriptor'],
          status: response['status'],
          bank_reconciliation_id: response['bank_reconciliation_id'],
          eci: response['eci'],
          capture_amount: response['capture_amount'],
          currency: response['currency'],
          failure_reason: response['failure_reason'],
          credit_card_token_id: response['credit_card_token_id'],
          payload: response.to_json
        }
      end
    end
  end
end
