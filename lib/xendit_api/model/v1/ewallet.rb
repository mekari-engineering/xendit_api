module XenditApi
  module Model
    module V1
      class Ewallet < XenditApi::Model::Base
        attr_accessor :id,
                      :business_id,
                      :reference_id,
                      :status,
                      :currency,
                      :charge_amount,
                      :capture_amount,
                      :channel_code,
                      :channel_properties,
                      :created

        attr_writer :actions,
                    :is_redirect_required,
                    :callback_url,
                    :void_status,
                    :voided_at,
                    :capture_now,
                    :payment_method_id,
                    :basket,
                    :metadata,
                    :updated,
                    :refunded_amount,
                    :checkout_method,
                    :customer_id,
                    :failure_code
      end
    end
  end
end
