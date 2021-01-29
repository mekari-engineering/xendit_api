module XenditApi
  module Model
    class Disbursement
      include ActiveModel::Model

      attr_accessor :user_id,
                    :external_id,
                    :amount,
                    :bank_code,
                    :account_holder_name,
                    :description,
                    :disbursement_description,
                    :status,
                    :id,
                    :email_to,
                    :email_cc,
                    :email_bcc,
                    :payload
    end
  end
end
