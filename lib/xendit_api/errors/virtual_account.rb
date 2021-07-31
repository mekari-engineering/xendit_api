module XenditApi
  module Errors
    module VirtualAccount
      class ResponseError < XenditApi::Errors::ResponseError; end

      class CallbackNotFound < ResponseError; end

      class BankNotSupported < ResponseError; end

      class ApiValidation < ResponseError; end

      class InvalidJsonFormat < ResponseError; end

      class VirtualAccountNumberOutsideRange < ResponseError; end

      class ExpirationDateNotSupported < ResponseError; end

      class ExpirationInvalid < ResponseError; end

      class SuggestedAmountNotSupported < ResponseError; end

      class ExpectedAmountRequired < ResponseError; end

      class MinimumExpectedAmount < ResponseError; end

      class MaximumExpectedAmount < ResponseError; end

      class CallbackVirtualAccountNameNotAllowed < ResponseError; end

      class DescriptionNotSupported < ResponseError; end

      class RequestForbidden < ResponseError; end

      class ClosedVaNotSupported < ResponseError; end

      class DuplicateCallbackVirtualAccount < ResponseError; end
    end
  end
end
