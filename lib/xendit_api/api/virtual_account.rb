require 'xendit_api/api/base'
require 'xendit_api/model/virtual_account'

module XenditApi
  module Api
    class VirtualAccount < XenditApi::Api::Base
      PATH = '/callback_virtual_accounts'.freeze

      def create(external_id:, name:, amount:, bank_code:)
        response = client.post(PATH,
                               external_id: external_id,
                               name: name,
                               expected_amount: amount,
                               is_closed: true,
                               is_single_use: true,
                               bank_code: bank_code)
        virtual_account_params = permitted_virtual_account_params(response)
        XenditApi::Model::VirtualAccount.new(virtual_account_params)
      end

      def update_to_expired(id)
        update_path = "#{PATH}/#{id}"
        one_year = 31_556_952
        expired_date = Time.now + one_year
        virtual_account = find(id)
        response = client.patch(update_path,
                                expected_amount: virtual_account.expected_amount,
                                expiration_date: expired_date.iso8601)
        virtual_account_params = permitted_virtual_account_params(response)
        XenditApi::Model::VirtualAccount.new(virtual_account_params)
      end

      def update(id, params)
        update_path = "#{PATH}/#{id}"
        response = client.patch(update_path, params)
        virtual_account_response = permitted_virtual_account_params(response)
        XenditApi::Model::VirtualAccount.new(virtual_account_response)
      end

      def find(id)
        find_path = "#{PATH}/#{id}"
        response = client.get(find_path, {})
        virtual_account_params = permitted_virtual_account_params(response)
        XenditApi::Model::VirtualAccount.new(virtual_account_params)
      end

      private

      def permitted_virtual_account_params(response = {})
        {
          owner_id: response['owner_id'],
          id: response['id'],
          external_id: response['external_id'],
          bank_code: response['bank_code'],
          merchant_code: response['merchant_code'],
          name: response['name'],
          account_number: response['account_number'],
          is_single_use: response['is_single_use'],
          suggested_amount: response['suggested_amount'],
          expected_amount: response['expected_amount'],
          status: response['status'],
          expiration_date: response['expiration_date'],
          is_closed: response['is_closed'],
          currency: response['currency'],
          payload: response.to_json
        }
      end
    end
  end
end
