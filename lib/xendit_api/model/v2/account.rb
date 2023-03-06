require 'xendit_api/model/base'

module XenditApi
  module Model
    module V2
      class Account < XenditApi::Model::Base
        attr_accessor :id,
                      :email,
                      :type,
                      :status,
                      :public_profile,
                      :created,
                      :updated,
                      :request_id
      end
    end
  end
end
