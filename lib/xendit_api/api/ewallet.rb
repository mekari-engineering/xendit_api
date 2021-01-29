module XenditPay
  module Api
    class Ewallet < XenditPay::Api::Base
      PATH = "/ewallets".freeze

      def get(params)
        response = client.get(PATH, params)
        XenditPay::Model::Ewallet.new(response)
      end

      def post(params:, ewallet_type:)
        response = client.post(PATH,
                               external_id: params[:external_id],
                               amount: params[:amount],
                               phone: params[:phone],
                               ewallet_type: ewallet_type)

        XenditPay::Model::Ewallet.new(response)
      end
    end
  end
end
