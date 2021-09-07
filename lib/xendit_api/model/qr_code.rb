require 'xendit_api/model/base'

module XenditApi
  module Model
    class QrCode < XenditApi::Model::Base
      attr_accessor :id,
                    :external_id,
                    :amount,
                    :description,
                    :qr_string,
                    :callback_url,
                    :type,
                    :status,
                    :created,
                    :updated,
                    :metadata
    end
  end
end
