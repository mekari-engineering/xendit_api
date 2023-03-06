require 'xendit_api/model/base'

module XenditApi
  module Model
    class Ewallet < XenditApi::Model::Base
      attr_accessor :transaction_date,
                    :business_id,
                    :amount,
                    :phone,
                    :external_id,
                    :ewallet_type,
                    :created,
                    :status,
                    :request_id
    end
  end
end
