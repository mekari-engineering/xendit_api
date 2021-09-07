require 'xendit_api/api/base'
require 'xendit_api/model/qr_code'
require 'xendit_api/model/qr_code_payment'

module XenditApi
  module Api
    class QrCode < XenditApi::Api::Base
      PATH = '/qr_codes'.freeze

      def create(params)
        response = @client.post(PATH, params)
        XenditApi::Model::QrCode.new(response.merge(payload: response.to_json))
      end

      def find(external_id)
        find_path = "#{PATH}/#{external_id}"
        response = @client.get(find_path)
        XenditApi::Model::QrCode.new(response.merge(payload: response.to_json))
      end

      def find_payments(external_id)
        find_payments_path = "#{PATH}/payments?external_id=#{external_id}"
        response = @client.get(find_payments_path)
        response.map do |payment|
          XenditApi::Model::QrCodePayment.new(payment.merge(payload: payment.to_json))
        end
      end
    end
  end
end
