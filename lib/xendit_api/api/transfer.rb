require 'xendit_api/api/base'
require 'xendit_api/model/transfer'

module XenditApi
  module Api
    class Transfer < XenditApi::Api::Base
      PATH = '/transfers'.freeze

      def create(params)
        headers = { 'Path-Group' => PATH }
        response = client.post(PATH, params, headers)
        XenditApi::Model::Transfer.new(response)
      end

      def find_by_reference(reference)
        headers = { 'Path-Group' => "#{PATH}/reference" }
        response = client.get("#{PATH}/reference=#{reference}", nil, headers)
        XenditApi::Model::Transfer.new(response)
      end
    end
  end
end
