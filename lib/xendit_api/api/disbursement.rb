require 'xendit_api/api/base'
require 'xendit_api/model/disbursement'

module XenditApi
  module Api
    class Disbursement < XenditApi::Api::Base
      PATH = '/disbursements'.freeze

      def create(params)
        response = client.post(PATH, params)
        XenditApi::Model::Disbursement.new(response.merge(payload: response.to_json))
      end

      def find_by_external_id(external_id)
        where_by_external_id(external_id).last
      end

      def where_by_external_id(external_id)
        response = client.get("#{self.class::PATH}/?external_id=#{external_id}", {})
        disbursements = []
        response.each do |disbursement|
          disbursements << XenditApi::Model::Disbursement.new(disbursement.merge(payload: response.to_json))
        end
        disbursements
      end
    end
  end
end
