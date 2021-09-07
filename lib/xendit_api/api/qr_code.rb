require 'xendit_api/api/base'
require 'xendit_api/model/qr_code'

module XenditApi
  module Api
    class QrCode < XenditApi::Api::Base
      PATH = '/qr_codes'.freeze

      def create(params)
        response = @client.post(PATH, params)
        XenditApi::Model::QrCode.new(response)
      end

      def find(id)
        find_path = "#{PATH}/#{id}"
        response = @client.get(find_path)
        XenditApi::Model::QrCode.new(response)
      end
    end
  end
end
