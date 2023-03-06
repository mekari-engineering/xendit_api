require 'xendit_api/api/base'
require 'xendit_api/model/qr_code'
require 'xendit_api/model/qr_code_payment'

module XenditApi
  module Api
    class QrCode < XenditApi::Api::Base
      PATH = '/qr_codes'.freeze

      def create(params, headers = {})
        response = @client.post(PATH, params, headers)
        XenditApi::Model::QrCode.new(response.body.merge(payload: response.body.to_json, request_id: response.headers['request-id']))
      end

      def find(external_id, headers = {})
        find_path = "#{PATH}/#{external_id}"
        response = @client.get(find_path, nil, headers)
        XenditApi::Model::QrCode.new(response.body.merge(payload: response.body.to_json, request_id: response.headers['request-id']))
      end

      def find_payments(external_id, headers = {})
        find_payments_path = "#{PATH}/payments?external_id=#{external_id}"
        response = @client.get(find_payments_path, nil, headers)
        response.body.map do |payment|
          XenditApi::Model::QrCodePayment.new(payment.merge(payload: payment.to_json, request_id: response.headers['request-id']))
        end
      end
    end
  end
end
