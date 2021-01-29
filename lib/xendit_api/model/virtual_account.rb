module XenditApi
  module Model
    class VirtualAccount
      include ActiveModel::Model

      attr_accessor :owner_id,
                    :id,
                    :external_id,
                    :bank_code,
                    :merchant_code,
                    :name,
                    :account_number,
                    :is_single_use,
                    :suggested_amount,
                    :expected_amount,
                    :status,
                    :expiration_date,
                    :is_closed,
                    :currency,
                    :payload
    end
  end
end
