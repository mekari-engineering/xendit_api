require 'xendit_api/model/base'

module XenditApi
  module Model
    class SplitRule < XenditApi::Model::Base
      attr_accessor :id,
                    :name,
                    :description,
                    :created,
                    :updated,
                    :routes
    end
  end
end
