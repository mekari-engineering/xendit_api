require 'xendit_api/api/base'
require 'xendit_api/model/ewallet'

module XenditApi
  module Api
    class Ewallet < XenditApi::Api::Base
      PATH = '/ewallets'.freeze

      def get(params)
        response = client.get(PATH, params)
        XenditApi::Model::Ewallet.new(response)
      end

      def post(params:, ewallet_type:)
        response = client.post(PATH,
                               external_id: params[:external_id],
                               amount: params[:amount],
                               phone: params[:phone],
                               ewallet_type: ewallet_type)

        XenditApi::Model::Ewallet.new(response)
      end
    end
  end
end
