require 'xendit_api/api/base'
require 'xendit_api/model/report'

module XenditApi
  module Api
    class Report < XenditApi::Api::Base
      PATH = '/reports'.freeze

      def create(params, headers = {})
        headers = headers.merge({ 'Path-Group' => PATH })
        response = client.post(PATH, params, headers)
        XenditApi::Model::Report.new(response)
      end
    end
  end
end
