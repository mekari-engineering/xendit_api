require 'spec_helper'
require 'xendit_api/api/ewallet'
require 'xendit_api/errors/ovo'
require 'xendit_api/client'

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

      pending 'returns success response' do
        VCR.use_cassette('xendit/ewallet/ovo/success') do
          ewallet_api = described_class.new(client)
          response = ewallet_api.post(params: params, ewallet_type: 'OVO')
          expect(response).to be_instance_of XenditApi::Model::Ewallet
          expect(response.transaction_date).to be_present
          expect(response.external_id).to eq 'nobu@mekari.com'
          expect(response.amount).to eq 1_000
          expect(response.ewallet_type).to eq 'OVO'
          expect(response.business_id).to be_present
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
          expect do
            ewallet_api = described_class.new(client)
            ewallet_api.post(params: params, ewallet_type: 'OVO')
            # FIXME
          end.to raise_error(XenditApi::Errors::ApiValidation)
        end
      end

      it 'raises error XenditApi::Errors::OVO::PaymentTimeout' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_payment_timeout') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4000, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error(XenditApi::Errors::OVO::PaymentTimeout, 'Payment was not authorized')
        end
      end

      it 'raises error XenditApi::Errors::OVO::DuplicatePayment' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_duplicate_payment') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4010, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error(XenditApi::Errors::OVO::DuplicatePayment, 'There is already payment for the same external ID')
        end
      end

      it 'raises error XenditApi::Errors::OVO::SendingRequest' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_sendit_request') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4020, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error(XenditApi::Errors::OVO::SendingRequest, 'Error while sending transaction to the e-ewallet provider')
        end
      end

      it 'raises error XenditApi::Errors::OVO::TransactionDeclined' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_transaction_declined') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4030, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error(XenditApi::Errors::OVO::TransactionDeclined, 'Transaction was declined')
        end
      end

      it 'raises error XenditApi::Errors::OVO::PhoneNumberNotRegistered' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_phone_number_not_registered') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4040, phone: '087310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error(XenditApi::Errors::OVO::PhoneNumberNotRegistered, "Phone number is not registered in the e-wallet provider's system")
        end
      end

      it 'raises error XenditApi::Errors::OVO::EwalletAppUnreacable' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_ewallet_app_unreachable') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 4050, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error(XenditApi::Errors::OVO::EwalletAppUnreacable, 'Your e-wallet app is not reachable by the provider')
        end
      end

      it 'raises error XenditApi::Errors::OVO::ExternalError' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_external_error') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 5000, phone: '082310202012' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error(XenditApi::Errors::OVO::ExternalError, 'External error. Please contact our support')
        end
      end

      it 'raises error XenditApi::Errors::UnknownError' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_unknown_error') do
          expect do
            ewallet_api = described_class.new(client)
            params = { external_id: '123', amount: 9999, phone: '082310202299' }
            ewallet_api.post(params: params, ewallet_type: 'OVO')
          end.to raise_error(XenditApi::Errors::UnknownError, 'Unknown error was triggered')
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
          end.to raise_error(XenditApi::Errors::OVO::PaymentNotFound, 'Payment not found')
        end
      end
    end
  end
end
