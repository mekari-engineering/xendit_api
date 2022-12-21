require 'xendit_api/api/base'
require 'xendit_api/model/disbursement'

module XenditApi
  module Api
    class Disbursement < XenditApi::Api::Base
      PATH = '/disbursements'.freeze

      def create(params, headers = {})
        response = client.post(PATH, params, headers)
        XenditApi::Model::Disbursement.new(response.merge(payload: response.to_json))
      end

      def find_by_external_id(external_id, headers = {})
        where_by_external_id(external_id, headers).first
      end

      def where_by_external_id(external_id, headers)
        response = client.get("#{self.class::PATH}/?external_id=#{external_id}", headers)
        disbursements = []
        response.each do |disbursement|
          disbursements << XenditApi::Model::Disbursement.new(disbursement.merge(payload: response.to_json))
        end
        disbursements
      end
    end
  end
end
