require 'xendit_api/client'
require 'xendit_api/api/base'
require 'xendit_api/model/credit_card'

module XenditApi
  module Api
    class CreditCard < XenditApi::Api::Base
      PATH = '/credit_card_charges'.freeze

      def charge(params, headers = {})
        response = client.post(PATH, params, headers)
        credit_card_params = permitted_credit_card_params(response)
        XenditApi::Model::CreditCard.new(credit_card_params)
      end

      def find(id, headers = {})
        find_path = "#{PATH}/#{id}"
        response = client.get(find_path, nil, headers)
        credit_card_params = permitted_credit_card_params(response)
        XenditApi::Model::CreditCard.new(credit_card_params)
      end

      private

      def permitted_credit_card_params(response = {})
        {
          id: response['id'],
          xid: response['xid'],
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
          issuing_bank_name: response['issuing_bank_name'],
          cvn_code: response['cvn_code'],
          card_fingerprint: response['card_fingerprint'],
          payload: response.to_json
        }
      end
    end
  end
end
