require 'xendit_api/model/base'

module XenditApi
  module Model
    class FeeRule < XenditApi::Model::Base
      attr_accessor :id,
                    :name,
                    :description,
                    :routes,
                    :created,
                    :updated,
                    :metadata,
                    :request_id
    end
  end
end
