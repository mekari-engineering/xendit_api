module XenditPay
  module Model
    class CreditCard
      include ActiveModel::Model

      attr_accessor :id,
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
                    :payload
    end
  end
end
