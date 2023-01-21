require 'xendit_api/api/base'
require 'xendit_api/model/v2/invoice'

module XenditApi
  module Api
    module V2
      class Invoice < XenditApi::Api::Base
        PATH = '/v2/invoices'.freeze

        def get(invoice_id)
          response = client.get("#{PATH}/#{invoice_id}")

          XenditApi::Model::V2::Invoice.new(response)
        end

        def get_by_external_id(external_id)
          response = client.get(PATH, {
                                  external_id: external_id
                                })

          response.map do |invoice|
            XenditApi::Model::V2::Invoice.new(invoice)
          end
        end

        def post(params:)
          response = client.post(PATH, params)

          XenditApi::Model::V2::Invoice.new(response)
        end
      end
    end
  end
end
