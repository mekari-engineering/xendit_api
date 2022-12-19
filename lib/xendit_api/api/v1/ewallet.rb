require 'xendit_api/api/base'
require 'xendit_api/model/v1/ewallet'

module XenditApi
  module Api
    module V1
      class Ewallet < XenditApi::Api::Base
        PATH = '/ewallets/charges'.freeze
        CHECKOUT_METHOD = 'ONE_TIME_PAYMENT'.freeze
        CURRENCY = 'IDR'.freeze

        def get(id)
          response = client.get("#{PATH}/#{id}")
          XenditApi::Model::V1::Ewallet.new(response)
        end

        def post(params:, payment_method:, headers: {})
          channel_code = find_channel_code(payment_method)
          channel_properties = get_channel_properties(channel_code, params)
          params = {
            reference_id: params[:reference_id],
            currency: CURRENCY,
            amount: params[:amount],
            checkout_method: CHECKOUT_METHOD,
            channel_code: channel_code,
            channel_properties: channel_properties
          }
          response = client.post(PATH, params, headers)

          XenditApi::Model::V1::Ewallet.new(response)
        end

        private

        def find_channel_code(payment_method)
          return 'ID_OVO' if payment_method.eql?(:ovo)

          ''
        end

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
end
