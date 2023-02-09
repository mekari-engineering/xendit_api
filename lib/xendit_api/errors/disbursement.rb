module XenditApi
  module Errors
    module Disbursement
      class Error < XenditApi::Errors::ResponseError; end
      class DescriptionNotFound < Error; end
      class NotEnoughBalance < Error; end
      class DuplicateTransactionError < Error; end
      class RecipientAccountNumberError < Error; end
      class RecipientAmountError < Error; end
      class MaximumTransferLimitError < Error; end
      class BankCodeNotSupported < Error; end
      class DirectDisbursementNotFound < Error; end
      class InvalidDestination < Error; end
    end
  end
end
