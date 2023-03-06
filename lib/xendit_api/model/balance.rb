require 'xendit_api/model/base'

module XenditApi
  module Model
    class Balance < XenditApi::Model::Base
      attr_accessor :balance,
                    :payload,
                    :request_id
    end
  end
end
