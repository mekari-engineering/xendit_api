require 'xendit_api/model/base'

module XenditApi
  module Model
    class Transaction < XenditApi::Model::Base
      attr_accessor :product_id,
                    :id,
                    :type,
                    :channel_code,
                    :reference_id,
                    :account_identifier,
                    :currency,
                    :amount,
                    :net_amount,
                    :cashflow,
                    :status,
                    :channel_category,
                    :business_id,
                    :created,
                    :updated,
                    :fee,
                    :settlement_status,
                    :estimated_settlement_time
    end
  end
end
