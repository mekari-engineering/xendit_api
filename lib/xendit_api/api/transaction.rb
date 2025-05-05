require 'xendit_api/api/base'
require 'xendit_api/model/transaction'

module XenditApi
  module Api
    class Transaction < XenditApi::Api::Base
      PATH = '/transactions'.freeze

      def list(query_string = '', headers = {})
        transactions_path = query_string.to_s.empty? ? PATH : "#{PATH}?#{query_string}"
        headers = headers.merge({ 'Path-Group' => PATH })
        response = @client.get(transactions_path, nil, headers)

        data = response['data'].map do |transaction|
          XenditApi::Model::Transaction.new(transaction)
        end

        next_query = response['has_more'] ? URI.parse(execute_next_data(response['links'])).query : nil

        OpenStruct.new(data: data, next_query: next_query)
      end

      private

      def execute_next_data(links)
        links.find { |link| link['rel'] == 'next' }['href']
      end
    end
  end
end
