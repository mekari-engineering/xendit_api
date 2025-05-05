require 'xendit_api/api/base'
require 'xendit_api/model/v2/invoice'

module XenditApi
  module Api
    module V2
      class Invoice < XenditApi::Api::Base
        PATH = '/v2/invoices'.freeze

        def get(invoice_id)
          headers = { 'Path-Group' => "#{PATH}/{invoice_id}" }
          response = client.get("#{PATH}/#{invoice_id}", nil, headers)

          XenditApi::Model::V2::Invoice.new(response)
        end

        def get_by_external_id(external_id)
          headers = { 'Path-Group' => PATH }
          response = client.get(PATH, {
                                  external_id: external_id
                                }, headers)

          response.map do |invoice|
            XenditApi::Model::V2::Invoice.new(invoice)
          end
        end

        def post(params:)
          headers = { 'Path-Group' => PATH }
          response = client.post(PATH, params, headers)

          XenditApi::Model::V2::Invoice.new(response)
        end
      end
    end
  end
end
