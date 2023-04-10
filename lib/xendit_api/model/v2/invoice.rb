require 'xendit_api/model/base'

module XenditApi
  module Model
    module V2
      class Invoice < XenditApi::Model::Base
        attr_accessor :id,
                      :user_id,
                      :external_id,
                      :status,
                      :merchant_name,
                      :merchant_profile_picture_url,
                      :amount,
                      :paid_amount,
                      :payer_email,
                      :payment_method,
                      :description,
                      :invoice_url,
                      :expiry_date,
                      :available_banks,
                      :available_retail_outlets,
                      :should_exclude_credit_card,
                      :should_send_email,
                      :created,
                      :updated,
                      :mid_label,
                      :currency,
                      :fixed_va,
                      :items,
                      :fees
      end
    end
  end
end
