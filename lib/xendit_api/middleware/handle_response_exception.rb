module XenditApi
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
        return true if response.nil?

        json_response = JSON.parse(response)
        json_response = json_response.first if json_response.is_a? Array

        return true if json_response['error_code'].nil?

        error_message = json_response['message']

        case json_response['error_code']
        when 'USER_DID_NOT_AUTHORIZE_THE_PAYMENT'
          raise XenditApi::Errors::OVO::PaymentTimeout, error_message
        when 'DUPLICATE_PAYMENT'
          raise XenditApi::Errors::OVO::DuplicatePayment, error_message
        when 'SENDING_TRANSACTION_ERROR'
          raise XenditApi::Errors::OVO::SendingRequest, error_message
        when 'USER_DECLINED_THE_TRANSACTION'
          raise XenditApi::Errors::OVO::TransactionDeclined, error_message
        when 'PHONE_NUMBER_NOT_REGISTERED'
          raise XenditApi::Errors::OVO::PhoneNumberNotRegistered, error_message
        when 'EWALLET_APP_UNREACHABLE'
          raise XenditApi::Errors::OVO::EwalletAppUnreacable, error_message
        when 'EXTERNAL_ERROR'
          raise XenditApi::Errors::OVO::ExternalError, error_message
        when 'PAYMENT_NOT_FOUND_ERROR'
          raise XenditApi::Errors::OVO::PaymentNotFound, error_message
        when 'CHANNEL_NOT_ACTIVATED'
          raise XenditApi::Errors::V1::Ewallet::ChannelNotActivated, error_message
        when 'CHANNEL_UNAVAILABLE'
          raise XenditApi::Errors::V1::Ewallet::ChannelUnavailable, error_message
        when 'DUPLICATE_ERROR'
          raise XenditApi::Errors::V1::Ewallet::DuplicateError, error_message
        when 'DATA_NOT_FOUND'
          raise XenditApi::Errors::V1::Ewallet::DataNotFound, error_message
        when 'API_VALIDATION_ERROR'
          raise XenditApi::Errors::ApiValidation, error_message
        when 'CALLBACK_VIRTUAL_ACCOUNT_NOT_FOUND_ERROR'
          raise XenditApi::Errors::VirtualAccount::CallbackNotFound, error_message
        when 'BANK_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::BankNotSupported, error_message
        when 'INVALID_JSON_FORMAT'
          raise XenditApi::Errors::VirtualAccount::InvalidJsonFormat, error_message
        when 'VIRTUAL_ACCOUNT_NUMBER_OUTSIDE_RANGE'
          raise XenditApi::Errors::VirtualAccount::VirtualAccountNumberOutsideRange, error_message
        when 'EXPIRATION_DATE_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::ExpirationDateNotSupported, error_message
        when 'EXPIRATION_DATE_INVALID_ERROR'
          raise XenditApi::Errors::VirtualAccount::ExpirationInvalid, error_message
        when 'SUGGESTED_AMOUNT_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::SuggestedAmountNotSupported, error_message
        when 'EXPECTED_AMOUNT_REQUIRED_ERROR'
          raise XenditApi::Errors::VirtualAccount::ExpectedAmountRequired, error_message
        when 'CLOSED_VA_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::ClosedVaNotSupported, error_message
        when 'DUPLICATE_CALLBACK_VIRTUAL_ACCOUNT_ERROR'
          raise XenditApi::Errors::VirtualAccount::DuplicateCallbackVirtualAccount, error_message
        when 'MAXIMUM_EXPECTED_AMOUNT_ERROR'
          raise XenditApi::Errors::VirtualAccount::MaximumExpectedAmount, error_message
        when 'CALLBACK_VIRTUAL_ACCOUNT_NAME_NOT_ALLOWED_ERROR'
          raise XenditApi::Errors::VirtualAccount::CallbackVirtualAccountNameNotAllowed, error_message
        when 'DESCRIPTION_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::DescriptionNotSupported, error_message
        when 'MINIMUM_EXPECTED_AMOUNT_ERROR'
          raise XenditApi::Errors::VirtualAccount::MinimumExpectedAmount, error_message
        when 'REQUEST_FORBIDDEN_ERROR'
          raise XenditApi::Errors::VirtualAccount::RequestForbidden, error_message
        # credit cards
        when 'INVALID_TOKEN_ID_ERROR'
          raise XenditApi::Errors::CreditCard::ChargeError, error_message
        # disbursements
        when 'DISBURSEMENT_DESCRIPTION_NOT_FOUND_ERROR'
          raise XenditApi::Errors::Disbursement::DescriptionNotFound, error_message
        when 'DIRECT_DISBURSEMENT_BALANCE_INSUFFICIENT_ERROR'
          raise XenditApi::Errors::Disbursement::NotEnoughBalance, error_message
        when 'DIRECT_DISBURSEMENT_NOT_FOUND_ERROR'
          raise XenditApi::Errors::Disbursement::DirectDisbursementNotFound, error_message
        when 'DUPLICATE_TRANSACTION_ERROR'
          raise XenditApi::Errors::Disbursement::DuplicateTransactionError, error_message
        when 'RECIPIENT_ACCOUNT_NUMBER_ERROR'
          raise XenditApi::Errors::Disbursement::RecipientAccountNumberError, error_message
        when 'RECIPIENT_AMOUNT_ERROR'
          raise XenditApi::Errors::Disbursement::RecipientAmountError, error_message
        when 'MAXIMUM_TRANSFER_LIMIT_ERROR'
          raise XenditApi::Errors::Disbursement::MaximumTransferLimitError, error_message
        when 'BANK_CODE_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::Disbursement::BankCodeNotSupported.new(error_message, json_response)
        when 'SERVER_ERROR'
          raise XenditApi::Errors::ServerError, error_message
        else
          raise XenditApi::Errors::UnknownError, error_message
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
