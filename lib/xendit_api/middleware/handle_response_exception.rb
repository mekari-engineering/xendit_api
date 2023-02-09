module XenditApi
  # rubocop:disable Metrics/ModuleLength
  module Middleware
    HandleResponseException = Struct.new(:app, :logger) do
      def call(env)
        app.call(env).on_complete do |response|
          if response.status.to_s.start_with?('5')
            logger.info("#{env.method.upcase} #{env.url} #{env.body}") if logger&.info
            raise XenditApi::Errors::ServerError, 'An unexpected error occurred, our team has been notified and will troubleshoot the issue.'
          end

          validate_response(response.body, env)
        end
      end

      private

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength
      def validate_response(response, env)
        return true if response.nil?

        json_response = JSON.parse(response)
        json_response = json_response.first if json_response.is_a? Array

        return true if json_response.nil?
        return true if json_response['error_code'].nil?

        logger.info("#{env.method.upcase} #{env.url} #{env.body}") if logger&.info

        error_message = json_response['message']

        case json_response['error_code']
        when 'USER_DID_NOT_AUTHORIZE_THE_PAYMENT'
          raise XenditApi::Errors::OVO::PaymentTimeout.new(error_message, json_response)
        when 'DUPLICATE_PAYMENT'
          raise XenditApi::Errors::OVO::DuplicatePayment.new(error_message, json_response)
        when 'SENDING_TRANSACTION_ERROR'
          raise XenditApi::Errors::OVO::SendingRequest.new(error_message, json_response)
        when 'USER_DECLINED_THE_TRANSACTION'
          raise XenditApi::Errors::OVO::TransactionDeclined.new(error_message, json_response)
        when 'PHONE_NUMBER_NOT_REGISTERED'
          raise XenditApi::Errors::OVO::PhoneNumberNotRegistered.new(error_message, json_response)
        when 'EWALLET_APP_UNREACHABLE'
          raise XenditApi::Errors::OVO::EwalletAppUnreacable.new(error_message, json_response)
        when 'EXTERNAL_ERROR'
          raise XenditApi::Errors::OVO::ExternalError.new(error_message, json_response)
        when 'PAYMENT_NOT_FOUND_ERROR'
          raise XenditApi::Errors::OVO::PaymentNotFound.new(error_message, json_response)
        when 'CHANNEL_NOT_ACTIVATED'
          raise XenditApi::Errors::V1::Ewallet::ChannelNotActivated.new(error_message, json_response)
        when 'DUPLICATE_ERROR'
          raise XenditApi::Errors::DuplicateError.new(error_message, json_response)
        when 'DATA_NOT_FOUND'
          raise XenditApi::Errors::DataNotFound.new(error_message, json_response)
        when 'API_VALIDATION_ERROR'
          # In this exception with custom the title since, the message from
          # could returns arrays (see the payload for the full messages)
          raise XenditApi::Errors::ApiValidation.new('Validation error', json_response)
        when 'CALLBACK_VIRTUAL_ACCOUNT_NOT_FOUND_ERROR'
          raise XenditApi::Errors::VirtualAccount::CallbackNotFound.new(error_message, json_response)
        when 'BANK_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::BankNotSupported.new(error_message, json_response)
        when 'INVALID_JSON_FORMAT'
          raise XenditApi::Errors::VirtualAccount::InvalidJsonFormat.new(error_message, json_response)
        when 'VIRTUAL_ACCOUNT_NUMBER_OUTSIDE_RANGE'
          raise XenditApi::Errors::VirtualAccount::VirtualAccountNumberOutsideRange.new(error_message, json_response)
        when 'EXPIRATION_DATE_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::ExpirationDateNotSupported.new(error_message, json_response)
        when 'EXPIRATION_DATE_INVALID_ERROR'
          raise XenditApi::Errors::VirtualAccount::ExpirationInvalid.new(error_message, json_response)
        when 'SUGGESTED_AMOUNT_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::SuggestedAmountNotSupported.new(error_message, json_response)
        when 'EXPECTED_AMOUNT_REQUIRED_ERROR'
          raise XenditApi::Errors::VirtualAccount::ExpectedAmountRequired.new(error_message, json_response)
        when 'CLOSED_VA_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::ClosedVaNotSupported.new(error_message, json_response)
        when 'DUPLICATE_CALLBACK_VIRTUAL_ACCOUNT_ERROR'
          raise XenditApi::Errors::VirtualAccount::DuplicateCallbackVirtualAccount.new(error_message, json_response)
        when 'MAXIMUM_EXPECTED_AMOUNT_ERROR'
          raise XenditApi::Errors::VirtualAccount::MaximumExpectedAmount.new(error_message, json_response)
        when 'CALLBACK_VIRTUAL_ACCOUNT_NAME_NOT_ALLOWED_ERROR'
          raise XenditApi::Errors::VirtualAccount::CallbackVirtualAccountNameNotAllowed.new(error_message, json_response)
        when 'DESCRIPTION_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::VirtualAccount::DescriptionNotSupported.new(error_message, json_response)
        when 'MINIMUM_EXPECTED_AMOUNT_ERROR'
          raise XenditApi::Errors::VirtualAccount::MinimumExpectedAmount.new(error_message, json_response)
        when 'REQUEST_FORBIDDEN_ERROR'
          raise XenditApi::Errors::VirtualAccount::RequestForbidden.new(error_message, json_response)
        # credit cards
        when 'INVALID_TOKEN_ID_ERROR'
          raise XenditApi::Errors::CreditCard::ChargeError.new(error_message, json_response)
        # disbursements
        when 'DISBURSEMENT_DESCRIPTION_NOT_FOUND_ERROR'
          raise XenditApi::Errors::Disbursement::DescriptionNotFound.new(error_message, json_response)
        when 'DIRECT_DISBURSEMENT_BALANCE_INSUFFICIENT_ERROR'
          raise XenditApi::Errors::Disbursement::NotEnoughBalance.new(error_message, json_response)
        when 'DIRECT_DISBURSEMENT_NOT_FOUND_ERROR'
          raise XenditApi::Errors::Disbursement::DirectDisbursementNotFound.new(error_message, json_response)
        when 'DUPLICATE_TRANSACTION_ERROR'
          raise XenditApi::Errors::Disbursement::DuplicateTransactionError.new(error_message, json_response)
        when 'RECIPIENT_ACCOUNT_NUMBER_ERROR'
          raise XenditApi::Errors::Disbursement::RecipientAccountNumberError.new(error_message, json_response)
        when 'RECIPIENT_AMOUNT_ERROR'
          raise XenditApi::Errors::Disbursement::RecipientAmountError.new(error_message, json_response)
        when 'MAXIMUM_TRANSFER_LIMIT_ERROR'
          raise XenditApi::Errors::Disbursement::MaximumTransferLimitError.new(error_message, json_response)
        when 'BANK_CODE_NOT_SUPPORTED_ERROR'
          raise XenditApi::Errors::Disbursement::BankCodeNotSupported.new(error_message, json_response)
        when 'INVALID_DESTINATION'
          raise XenditApi::Errors::Disbursement::InvalidDestination.new(error_message, json_response)
        when 'SERVER_ERROR'
          raise XenditApi::Errors::ServerError.new(error_message, json_response)
        else
          raise XenditApi::Errors::UnknownError.new(error_message, json_response)
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
