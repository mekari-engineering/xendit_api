require 'xendit_api/api/base'
require 'xendit_api/model/split_rule'

module XenditApi
  module Api
    class SplitRule < XenditApi::Api::Base
      PATH = '/split_rules'.freeze

      def create(params)
        headers = { 'Path-Group' => PATH }
        response = client.post(PATH, params, headers)
        XenditApi::Model::SplitRule.new(response)
      end
    end
  end
end
