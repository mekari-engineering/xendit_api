require 'spec_helper'
require 'xendit_api/api/v1/ewallet'
require 'xendit_api/errors/v1/ewallet'
require 'xendit_api/client'

RSpec.describe XenditApi::Api::V1::Ewallet do
  let(:client) { XenditApi::Client.new }

  describe '#post' do
    context 'with valid params' do
      let(:params) do
        {
          reference_id: 'eacd7788-8864-421c-a39c-9c59c3ee875c',
          amount: 1_000,
          mobile_number: '+6281234567890'
        }
      end

      it 'returns success response' do
        VCR.use_cassette('xendit/v1/ewallet/ovo/success') do
          ewallet_api = described_class.new(client)
          response = ewallet_api.post(params: params, payment_method: :ovo)
          expect(response).to be_instance_of XenditApi::Model::V1::Ewallet
          expect(response.created).not_to be_nil
          expect(response.reference_id).to eq 'eacd7788-8864-421c-a39c-9c59c3ee875c'
          expect(response.charge_amount).to eq 1_000
          expect(response.capture_amount).to eq 1_000
          expect(response.channel_code).to eq 'ID_OVO'
          expect(response.business_id).not_to be_nil
        end
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          reference_id: '9c833514-c47d-49f2-adb0-f49ab88a5f44',
          amount: 1_000,
          mobile_number: '0'
        }
      end

      it 'raise error phone number not registered' do
        VCR.use_cassette('xendit/v1/ewallet/ovo/errors_invalid_phone_number') do
          error_payload = { 'error_code' => 'API_VALIDATION_ERROR', 'message' => 'Failed to validate the request, 1 error occurred.', 'errors' => [{ 'path' => 'body.channel_properties.mobile_number', 'message' => "JSON string doesn't match the regular expression \"^\\\\+?[1-9]\\\\d{1,14}$\"" }] }
          expect do
            ewallet_api = described_class.new(client)
            ewallet_api.post(params: params, payment_method: :ovo)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::ApiValidation
            expect(error.message).to eq 'Validation error'
            expect(error.payload).to eq error_payload
          end
        end
      end

      it 'raise error channel not activated' do
        VCR.use_cassette('xendit/v1/ewallet/ovo/errors_channel_not_activated') do
          expect do
            ewallet_api = described_class.new(client)
            params = { reference_id: 'fa37759f-6bb0-4b7f-9701-2b6f43af01c9', amount: 10_100, mobile_number: '+6282310202012' }
            ewallet_api.post(params: params, payment_method: :ovo)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::V1::Ewallet::ChannelNotActivated
            expect(error.message).to eq 'Payment request failed because this specific payment channel has not been activated. Please activate the payment channel via your dashboard or our customer service.'
            expect(error.payload).to eq({ 'error_code' => 'CHANNEL_NOT_ACTIVATED', 'message' => 'Payment request failed because this specific payment channel has not been activated. Please activate the payment channel via your dashboard or our customer service.' })
          end
        end
      end

      it 'raise error channel unavailable' do
        VCR.use_cassette('xendit/v1/ewallet/ovo/errors_channel_unvailable') do
          expect do
            ewallet_api = described_class.new(client)
            params = { reference_id: '7f156109-5f7a-479a-84db-f59c5ab38766', amount: 10_101, mobile_number: '+6282310202012' }
            ewallet_api.post(params: params, payment_method: :ovo)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::V1::Ewallet::ChannelUnavailable
            expect(error.message).to eq 'The payment channel requested is currently experiencing unexpected issues. The eWallet provider will be notified to resolve this issue.'
            expect(error.payload).to eq({ 'error_code' => 'CHANNEL_UNAVAILABLE', 'message' => 'The payment channel requested is currently experiencing unexpected issues. The eWallet provider will be notified to resolve this issue.' })
          end
        end
      end

      it 'raise error server error' do
        VCR.use_cassette('xendit/v1/ewallet/ovo/errors_server_error') do
          expect do
            ewallet_api = described_class.new(client)
            params = { reference_id: '434c9cc3-72ab-4ec0-82ba-488d040c15c1', amount: 10_102, mobile_number: '+6282310202012' }
            ewallet_api.post(params: params, payment_method: :ovo)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::ServerError
            expect(error.message).to eq 'An unexpected error occurred, our team has been notified and will troubleshoot the issue.'
            expect(error.payload).to eq({ 'error_code' => 'SERVER_ERROR', 'message' => 'An unexpected error occurred, our team has been notified and will troubleshoot the issue.' })
          end
        end
      end

      it 'raises error XenditApi::Errors::DuplicateError' do
        VCR.use_cassette('xendit/v1/ewallet/ovo/errors_duplicate_payment') do
          expect do
            ewallet_api = described_class.new(client)
            params = { reference_id: 'eacd7788-8864-421c-a39c-9c59c3ee875c', amount: 4000, mobile_number: '+6282310202012' }
            ewallet_api.post(params: params, payment_method: :ovo)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::DuplicateError
            expect(error.message).to eq 'There is already a charge request with the same reference_id.'
            expect(error.payload).to eq({ 'error_code' => 'DUPLICATE_ERROR', 'message' => 'There is already a charge request with the same reference_id.' })
          end
        end
      end

      it 'raises error XenditApi::Errors::UnknownError' do
        VCR.use_cassette('xendit/v1/ewallet/ovo/errors_unknown_error') do
          expect do
            ewallet_api = described_class.new(client)
            params = { reference_id: '307e9c34-7fed-45fe-b6d6-1f77bbbe872e', amount: 9999, mobile_number: '+6282310202299' }
            ewallet_api.post(params: params, payment_method: :ovo)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::UnknownError
            expect(error.message).to eq 'Unknown error was triggered'
            expect(error.payload).to eq({ 'error_code' => 'UNKNOWN', 'message' => 'Unknown error was triggered' })
          end
        end
      end
    end
  end

  describe '#get' do
    context 'when payment was complete' do
      it 'returns expected response' do
        VCR.use_cassette('xendit/v1/ewallet/ovo/get_complete_payment') do
          ewallet_api = described_class.new(client)
          id = 'ewc_5459d09c-6393-43ae-bbbd-e600b9706743'
          response = ewallet_api.get(id)
          expect(response).to be_instance_of XenditApi::Model::V1::Ewallet
          expect(response.charge_amount).to eq 1000
          expect(response.capture_amount).to eq 1000
          expect(response.reference_id).to eq 'eacd7788-8864-421c-a39c-9c59c3ee875c'
          expect(response.business_id).to eq '596d988e56b5a3c45be75e6e'
          expect(response.channel_code).to eq 'ID_OVO'
          expect(response.status).to eq 'SUCCEEDED'
        end
      end
    end

    context 'when payment not found' do
      it 'returns error response' do
        VCR.use_cassette('xendit/v1/ewallet/ovo/get_payment_not_found') do
          expect do
            ewallet_api = described_class.new(client)
            random_uuid = 'ewc_d351c488-fd5c-4a41-975f-f94614f7628f'
            ewallet_api.get(random_uuid)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::DataNotFound
            expect(error.message).to eq 'Charge request not found'
            expect(error.payload).to eq({ 'error_code' => 'DATA_NOT_FOUND', 'message' => 'Charge request not found' })
          end
        end
      end
    end
  end
end
