module XenditApi
  module Errors
    module OVO
      class ResponseError < StandardError; end

      class PaymentTimeout < ResponseError; end

      class DuplicateError < ResponseError; end

      class PhoneNumberNotRegistered < ResponseError; end

      class EwalletAppUnreacable < ResponseError; end

      class ExternalError < ResponseError; end

      class InvalidPhoneNumber < ResponseError; end

      class PaymentNotFound < ResponseError; end

      class ChannelNotActivated < ResponseError; end

      class ChannelUnavailable < ResponseError; end

      class ServerError < ResponseError; end

      class MaximumLimitReached < ResponseError; end

      class UnknownError < ResponseError; end
    end
  end
end
