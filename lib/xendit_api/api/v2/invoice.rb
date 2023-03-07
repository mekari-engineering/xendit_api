require 'xendit_api/api/base'
require 'xendit_api/model/v2/invoice'

module XenditApi
  module Api
    module V2
      class Invoice < XenditApi::Api::Base
        PATH = '/v2/invoices'.freeze

        def get(invoice_id)
          response = client.get_response("#{PATH}/#{invoice_id}")

          XenditApi::Model::V2::Invoice.new(response.body.merge(request_id: response.headers['request-id']))
        end

        def get_by_external_id(external_id)
          response = client.get_response(PATH, {
                                  external_id: external_id
                                })

          response.body.map do |invoice|
            XenditApi::Model::V2::Invoice.new(invoice.merge(request_id: response.headers['request-id']))
          end
        end

        def post(params:)
          response = client.post_response(PATH, params)

          XenditApi::Model::V2::Invoice.new(response.body.merge(request_id: response.headers['request-id']))
        end
      end
    end
  end
end
