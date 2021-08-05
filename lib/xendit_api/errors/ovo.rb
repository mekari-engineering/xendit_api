module XenditApi
  module Errors
    module OVO
      class ResponseError < XenditApi::Errors::ResponseError; end

      class PaymentTimeout < ResponseError; end

      class DuplicatePayment < ResponseError; end

      class SendingRequest < ResponseError; end

      class TransactionDeclined < ResponseError; end

      class PhoneNumberNotRegistered < ResponseError; end

      class EwalletAppUnreacable < ResponseError; end

      class ExternalError < ResponseError; end

      class InvalidPhoneNumber < ResponseError; end

      class PaymentNotFound < ResponseError; end

      class UnknownError < ResponseError; end
    end
  end
end
