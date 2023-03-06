require 'xendit_api/model/base'

module XenditApi
  module Model
    class CreditCard < XenditApi::Model::Base
      attr_accessor :id,
                    :xid,
                    :cavv,
                    :created,
                    :business_id,
                    :authorized_amount,
                    :approval_code,
                    :external_id,
                    :merchant_id,
                    :merchant_reference_code,
                    :masked_card_number,
                    :charge_type,
                    :card_brand,
                    :card_type,
                    :descriptor,
                    :status,
                    :bank_reconciliation_id,
                    :eci,
                    :capture_amount,
                    :currency,
                    :failure_reason,
                    :credit_card_token_id,
                    :payload,
                    :authorization_id,
                    :issuing_bank_name,
                    :cvn_code,
                    :card_fingerprint,
                    :request_id
    end
  end
end
