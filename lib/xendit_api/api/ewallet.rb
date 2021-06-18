require 'xendit_api/api/base'
require 'xendit_api/model/ewallet'

module XenditApi
  module Api
    class Ewallet < XenditApi::Api::Base
      PATH = '/ewallets'.freeze
      CHECKOUT_METHOD = 'ONE_TIME_PAYMENT'.freeze
      CURRENCY = 'IDR'.freeze

      def get(id:)
        response = client.get("#{PATH}/charges/#{id}")
        XenditApi::Model::Ewallet.new(response)
      end

      def post(params:, channel_code:)
        channel_properties = get_channel_properties(channel_code, params)
        response = client.post("#{PATH}/charges",
                               reference_id: params[:reference_id],
                               currency: CURRENCY,
                               amount: params[:amount],
                               checkout_method: CHECKOUT_METHOD,
                               channel_code: channel_code,
                               channel_properties: channel_properties)

        XenditApi::Model::Ewallet.new(response)
      end

      private

      def get_channel_properties(channel_code, params)
        return ovo_channel_properties(params) if channel_code == 'ID_OVO'

        {}
      end

      def ovo_channel_properties(params)
        {
          mobile_number: params[:mobile_number]
        }
      end
    end
  end
end
