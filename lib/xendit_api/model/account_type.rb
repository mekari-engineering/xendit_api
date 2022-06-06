require 'xendit_api/model/base'

module XenditApi
  module Model
    class AccountType < XenditApi::Model::Base
      CASH = 'CASH'.freeze
      HOLDING = 'HOLDING'.freeze
      TAX = 'TAX'.freeze
    end
  end
end
