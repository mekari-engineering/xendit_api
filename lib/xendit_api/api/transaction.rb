require 'xendit_api/api/base'
require 'xendit_api/model/transaction'

module XenditApi
  module Api
    class Transaction < XenditApi::Api::Base
      PATH = '/transactions'.freeze

      def list(query_string = '', headers = {})
        transactions_path = query_string.to_s.empty? ? PATH : "#{PATH}?#{query_string}"
        response = @client.get_response(transactions_path, nil, headers)

        data = response.body['data'].map do |transaction|
          XenditApi::Model::Transaction.new(transaction)
        end

        next_query = response.body['has_more'] ? URI.parse(execute_next_data(response.body['links'])).query : nil

        OpenStruct.new(data: data, next_query: next_query, request_id: response.headers['request-id'])
      end

      private

      def execute_next_data(links)
        links.find { |link| link['rel'] == 'next' }['href']
      end
    end
  end
end
