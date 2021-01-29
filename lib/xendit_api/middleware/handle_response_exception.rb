module XenditPay
  module Middleware
    class HandleResponseException < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do |response|
          validate_response(response.body)
        end
      end

      private

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength
      def validate_response(response)
        return true if response.blank?

        json_response = JSON.parse(response)
        return true if json_response["error_code"].blank?

        error_message = json_response["message"]

        case json_response["error_code"]
        when "USER_DID_NOT_AUTHORIZE_THE_PAYMENT"
          raise XenditPay::Errors::OVO::PaymentTimeout, error_message
        when "DUPLICATE_PAYMENT"
          raise XenditPay::Errors::OVO::DuplicatePayment, error_message
        when "SENDING_TRANSACTION_ERROR"
          raise XenditPay::Errors::OVO::SendingRequest, error_message
        when "USER_DECLINED_THE_TRANSACTION"
          raise XenditPay::Errors::OVO::TransactionDeclined, error_message
        when "PHONE_NUMBER_NOT_REGISTERED"
          raise XenditPay::Errors::OVO::PhoneNumberNotRegistered, error_message
        when "EWALLET_APP_UNREACHABLE"
          raise XenditPay::Errors::OVO::EwalletAppUnreacable, error_message
        when "EXTERNAL_ERROR"
          raise XenditPay::Errors::OVO::ExternalError, error_message
        when "PAYMENT_NOT_FOUND_ERROR"
          raise XenditPay::Errors::OVO::PaymentNotFound, error_message
        when "API_VALIDATION_ERROR"
          raise XenditPay::Errors::ApiValidation, error_message
        when "CALLBACK_VIRTUAL_ACCOUNT_NOT_FOUND_ERROR"
          raise XenditPay::Errors::VirtualAccount::CallbackNotFound, error_message
        when "BANK_NOT_SUPPORTED_ERROR"
          raise XenditPay::Errors::VirtualAccount::BankNotSupported, error_message
        when "INVALID_JSON_FORMAT"
          raise XenditPay::Errors::VirtualAccount::InvalidJsonFormat, error_message
        when "VIRTUAL_ACCOUNT_NUMBER_OUTSIDE_RANGE"
          raise XenditPay::Errors::VirtualAccount::VirtualAccountNumberOutsideRange, error_message
        when "EXPIRATION_DATE_NOT_SUPPORTED_ERROR"
          raise XenditPay::Errors::VirtualAccount::ExpirationDateNotSupported, error_message
        when "EXPIRATION_DATE_INVALID_ERROR"
          raise XenditPay::Errors::VirtualAccount::ExpirationInvalid, error_message
        when "SUGGESTED_AMOUNT_NOT_SUPPORTED_ERROR"
          raise XenditPay::Errors::VirtualAccount::SuggestedAmountNotSupported, error_message
        when "EXPECTED_AMOUNT_REQUIRED_ERROR"
          raise XenditPay::Errors::VirtualAccount::ExpectedAmountRequired, error_message
        when "CLOSED_VA_NOT_SUPPORTED_ERROR"
          raise XenditPay::Errors::VirtualAccount::ClosedVaNotSupported, error_message
        when "DUPLICATE_CALLBACK_VIRTUAL_ACCOUNT_ERROR"
          raise XenditPay::Errors::VirtualAccount::DuplicateCallbackVirtualAccount, error_message
        when "MAXIMUM_EXPECTED_AMOUNT_ERROR"
          raise XenditPay::Errors::VirtualAccount::MaximumExpectedAmount, error_message
        when "CALLBACK_VIRTUAL_ACCOUNT_NAME_NOT_ALLOWED_ERROR"
          raise XenditPay::Errors::VirtualAccount::CallbackVirtualAccountNameNotAllowed, error_message
        when "DESCRIPTION_NOT_SUPPORTED_ERROR"
          raise XenditPay::Errors::VirtualAccount::DescriptionNotSupported, error_message
        when "MINIMUM_EXPECTED_AMOUNT_ERROR"
          raise XenditPay::Errors::VirtualAccount::MinimumExpectedAmount, error_message
        when "REQUEST_FORBIDDEN_ERROR"
          raise XenditPay::Errors::VirtualAccount::RequestForbidden, error_message
        # credit cards
        when "INVALID_TOKEN_ID_ERROR"
          raise XenditPay::Errors::CreditCard::ChargeError, error_message
        # disbursements
        when "DISBURSEMENT_DESCRIPTION_NOT_FOUND_ERROR"
          raise XenditPay::Errors::Disbursement::DescriptionNotFound, error_message
        when "DIRECT_DISBURSEMENT_BALANCE_INSUFFICIENT_ERROR"
          raise XenditPay::Errors::Disbursement::NotEnoughBalance, error_message
        when "DUPLICATE_TRANSACTION_ERROR"
          raise XenditPay::Errors::Disbursement::DuplicateTransactionError, error_message
        when "RECIPIENT_ACCOUNT_NUMBER_ERROR"
          raise XenditPay::Errors::Disbursement::RecipientAccountNumberError, error_message
        when "RECIPIENT_AMOUNT_ERROR"
          raise XenditPay::Errors::Disbursement::RecipientAmountError, error_message
        when "MAXIMUM_TRANSFER_LIMIT_ERROR"
          raise XenditPay::Errors::Disbursement::MaximumTransferLimitError, error_message
        when "BANK_CODE_NOT_SUPPORTED_ERROR"
          raise XenditPay::Errors::Disbursement::BankCodeNotSupported, error_message
        when "SERVER_ERROR"
          raise XenditPay::Errors::ServerError, error_message
        else
          raise XenditPay::Errors::UnknownError, error_message
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
