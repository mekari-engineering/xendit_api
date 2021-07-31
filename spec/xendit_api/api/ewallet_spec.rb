require 'spec_helper'

RSpec.describe XenditApi::Api::Ewallet do
  let(:client) { XenditApi::Client.new }

  describe '#post' do
    context 'with valid params' do
      let(:params) do
        {
          external_id: 'nobu@mekari.com',
          amount: 1_000,
          phone: '081234567890'
        }
      end

      it 'returns success response' do
        VCR.use_cassette('xendit/ewallet/ovo/success') do
          ewallet_api = described_class.new(client)
          response = ewallet_api.post(params: params, ewallet_type: 'OVO')
          expect(response).to be_instance_of XenditApi::Model::Ewallet
          expect(response.transaction_date).not_to be_nil
          expect(response.external_id).to eq 'nobu@mekari.com'
          expect(response.amount).to eq 1_000
          expect(response.ewallet_type).to eq 'OVO'
          expect(response.business_id).not_to be_nil
        end
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          external_id: 'nubu@mekari.com',
          amount: 1_000,
          phone: '0'
        }
      end

      it 'raise error phone number not registered' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_invalid_phone_number') do
          error_payload = { 'error_code' => 'API_VALIDATION_ERROR', 'errors' => [{ 'message' => '"phone" length must be at least 9 characters long', 'path' => ['phone'], 'type' => 'string.min', 'context' => { 'limit' => 9, 'value' => '0', 'key' => 'phone', 'label' => 'phone' } }] }
          expect do
            ewallet_api = described_class.new(client)
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::ApiValidation
            expect(error.message).to eq 'Validation error'
            expect(error.payload).to eq error_payload
          end
        end
      end

      it 'raises error XenditApi::Errors::OVO::PaymentTimeout' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_payment_timeout') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4000, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::OVO::PaymentTimeout
            expect(error.message).to eq 'Payment was not authorized'
            expect(error.payload).to eq({ 'error_code' => 'USER_DID_NOT_AUTHORIZE_THE_PAYMENT', 'message' => 'Payment was not authorized' })
          end
        end
      end

      it 'raises error XenditApi::Errors::OVO::DuplicatePayment' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_duplicate_payment') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4010, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::OVO::DuplicatePayment
            expect(error.message).to eq 'There is already payment for the same external ID'
            expect(error.payload).to eq({ 'error_code' => 'DUPLICATE_PAYMENT', 'message' => 'There is already payment for the same external ID' })
          end
        end
      end

      it 'raises error XenditApi::Errors::OVO::SendingRequest' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_sendit_request') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4020, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::OVO::SendingRequest
            expect(error.message).to eq 'Error while sending transaction to the e-ewallet provider'
            expect(error.payload).to eq({ 'error_code' => 'SENDING_TRANSACTION_ERROR', 'message' => 'Error while sending transaction to the e-ewallet provider' })
          end
        end
      end

      it 'raises error XenditApi::Errors::OVO::TransactionDeclined' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_transaction_declined') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4030, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::OVO::TransactionDeclined
            expect(error.message).to eq 'Transaction was declined'
            expect(error.payload).to eq({ 'error_code' => 'USER_DECLINED_THE_TRANSACTION', 'message' => 'Transaction was declined' })
          end
        end
      end

      it 'raises error XenditApi::Errors::OVO::PhoneNumberNotRegistered' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_phone_number_not_registered') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4040, phone: '087310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::OVO::PhoneNumberNotRegistered
            expect(error.message).to eq "Phone number is not registered in the e-wallet provider's system"
            expect(error.payload).to eq({ 'error_code' => 'PHONE_NUMBER_NOT_REGISTERED', 'message' => "Phone number is not registered in the e-wallet provider's system" })
          end
        end
      end

      it 'raises error XenditApi::Errors::OVO::EwalletAppUnreacable' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_ewallet_app_unreachable') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4050, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::OVO::EwalletAppUnreacable
            expect(error.message).to eq 'Your e-wallet app is not reachable by the provider'
            expect(error.payload).to eq({ 'error_code' => 'EWALLET_APP_UNREACHABLE', 'message' => 'Your e-wallet app is not reachable by the provider' })
          end
        end
      end

      it 'raises error XenditApi::Errors::OVO::ExternalError' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_external_error') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 5000, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::OVO::ExternalError
            expect(error.message).to eq 'External error. Please contact our support'
            expect(error.payload).to eq({ 'error_code' => 'EXTERNAL_ERROR', 'message' => 'External error. Please contact our support' })
          end
        end
      end

      it 'raises error XenditApi::Errors::UnknownError' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_unknown_error') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 9999, phone: '082310202299' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::UnknownError
            expect(error.message).to eq 'Unknown error was triggered'
            expect(error.payload).to eq({ 'error_code' => 'UNKNOWN_ERROR', 'message' => 'Unknown error was triggered' })
          end
        end
      end
    end
  end

  describe '#get' do
    context 'when payment was complete' do
      it 'returns expected response' do
        VCR.use_cassette('xendit/ewallet/ovo/get_complete_payment') do
          ewallet_api = described_class.new(client)
          external_id = '12345'
          response = ewallet_api.get(external_id: external_id)
          expect(response).to be_instance_of XenditApi::Model::Ewallet
          expect(response.amount).to eq 1000
          expect(response.external_id).to eq '12345'
          expect(response.business_id).to eq '12121212'
          expect(response.ewallet_type).to eq 'OVO'
          expect(response.status).to eq 'COMPLETED'
        end
      end
    end

    context 'when payment not found' do
      it 'returns error response' do
        VCR.use_cassette('xendit/ewallet/ovo/get_payment_not_found') do
          expect do
            ewallet_api = described_class.new(client)
            ewallet_api.get(external_id: nil)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::OVO::PaymentNotFound
            expect(error.message).to eq 'Payment not found'
            expect(error.payload).to eq({ 'error_code' => 'PAYMENT_NOT_FOUND_ERROR', 'message' => 'Payment not found' })
          end
        end
      end
    end
  end
end
