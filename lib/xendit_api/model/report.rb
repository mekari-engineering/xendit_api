require 'xendit_api/model/base'

module XenditApi
  module Model
    class Report < XenditApi::Model::Base
      attr_accessor :id,
                    :type,
                    :status,
                    :filter,
                    :from,
                    :to,
                    :format,
                    :url,
                    :currency,
                    :business_id,
                    :created,
                    :updated
    end
  end
end
