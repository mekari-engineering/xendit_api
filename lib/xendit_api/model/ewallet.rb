module XenditPay
  module Model
    class Ewallet
      include ActiveModel::Model

      attr_accessor :transaction_date,
                    :business_id,
                    :amount,
                    :phone,
                    :external_id,
                    :ewallet_type,
                    :created,
                    :status
    end
  end
end
