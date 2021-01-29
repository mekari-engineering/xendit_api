module XenditPay
  module Api
    class Disbursement < XenditPay::Api::Base
      PATH = "/disbursements".freeze

      def create(params)
        response = client.post(PATH, params)
        XenditPay::Model::Disbursement.new(response.merge(payload: response.to_json))
      end
    end
  end
end
