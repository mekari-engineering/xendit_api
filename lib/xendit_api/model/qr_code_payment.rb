require 'xendit_api/model/base'
require 'xendit_api/model/qr_code'

module XenditApi
  module Model
    class QrCodePayment < XenditApi::Model::Base
      attr_accessor :id,
                    :amount,
                    :created,
                    :status,
                    :payload,
                    :request_id

      attr_writer :qr_code

      def qr_code
        XenditApi::Model::QrCode.new(@qr_code)
      end
    end
  end
end
