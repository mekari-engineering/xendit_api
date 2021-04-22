module XenditApi
  module Errors
    module CreditCard
      class ResponseError < StandardError; end

      class ChargeError < ResponseError; end

      class CardDeclined < ResponseError
        def message
          'The card you are trying to capture has been declined by the issuing bank.'
        end
      end

      class ExpiredCard < ResponseError
        def message
          'The card you are trying to capture is expired.'
        end
      end

      class InsufficientBalance < ResponseError
        def message
          'The card you are trying to capture does not have enough balance to complete the capture.'
        end
      end

      class StolenCard < ResponseError
        def message
          'The card you are trying to capture has been marked as stolen.'
        end
      end

      class InactiveCard < ResponseError
        def message
          'The card you are trying to capture is inactive.'
        end
      end

      class InvalidCvn < ResponseError
        def message
          'Invalid CVN number'
        end
      end
    end
  end
end
