require 'spec_helper'

RSpec.describe XenditApi::Api::QrCode do
  let(:client) { XenditApi::Client.new(ENV['XENDIT_SECRET_KEY']) }

  describe '#create' do
    it 'returns expected response' do
      VCR.use_cassette('xendit_api/api/qr_codes/valid') do
        qr_code = described_class.new(client)
        params = {
          external_id: 'sample-qr-code',
          type: 'DYNAMIC',
          callback_url: 'https://webhook.site/cc1e188a-cd5a-4a7e-b7f9-413a2289b580',
          amount: 100_000
        }
        response = qr_code.create(params)
        expect(response).to be_instance_of XenditApi::Model::QrCode
        expect(response.id).to eq 'qr_0c5dab3c-eaac-4348-bb43-4e4884425dd8'
        expect(response.external_id).to eq 'sample-qr-code'
        expect(response.amount).to eq 100_000
        expect(response.description).to eq ''
        expect(response.qr_string).to eq 'mock-QR-string-use-simulate-payment-to-test-flow'
        expect(response.callback_url).to eq 'https://webhook.site/cc1e188a-cd5a-4a7e-b7f9-413a2289b580'
        expect(response.type).to eq 'DYNAMIC'
        expect(response.status).to eq 'ACTIVE'
        expect(response.created).to eq '2021-09-07T06:37:28.827Z'
        expect(response.updated).to eq '2021-09-07T06:37:28.827Z'
        expect(response.metadata).to eq nil
        expect(response.payload).not_to eq nil
        expect(response.request_id).to eq '835390137024978821'
      end
    end

    it 'returns expected response with valid but with new response attribute' do
      VCR.use_cassette('xendit_api/api/qr_codes/valid_2') do
        qr_code = described_class.new(client)
        params = {
          external_id: 'sample-qr-code',
          type: 'DYNAMIC',
          callback_url: 'https://webhook.site/cc1e188a-cd5a-4a7e-b7f9-413a2289b580',
          amount: 100_000
        }
        response = qr_code.create(params)
        expect(response).to be_instance_of XenditApi::Model::QrCode
        expect(response.id).to eq 'qr_0c5dab3c-eaac-4348-bb43-4e4884425dd8'
        expect(response.external_id).to eq 'sample-qr-code'
        expect(response.amount).to eq 100_000
        expect(response.description).to eq ''
        expect(response.qr_string).to eq 'mock-QR-string-use-simulate-payment-to-test-flow'
        expect(response.callback_url).to eq 'https://webhook.site/cc1e188a-cd5a-4a7e-b7f9-413a2289b580'
        expect(response.type).to eq 'DYNAMIC'
        expect(response.status).to eq 'ACTIVE'
        expect(response.created).to eq '2021-09-07T06:37:28.827Z'
        expect(response.updated).to eq '2021-09-07T06:37:28.827Z'
        expect(response.metadata).to eq nil
        expect(response.payload).not_to eq nil
        expect(response.request_id).to eq '835390137024978822'
      end
    end

    it 'raise error duplicate external id' do
      VCR.use_cassette('xendit_api/api/qr_codes/error_duplicate_external_id') do
        qr_code = described_class.new(client)
        params = {
          external_id: 'sample-qr-code',
          type: 'DYNAMIC',
          callback_url: 'https://webhook.site/cc1e188a-cd5a-4a7e-b7f9-413a2289b580',
          amount: 100_000
        }
        expect do
          qr_code.create(params)
        end.to raise_error XenditApi::Errors::DuplicateError
      end
    end

    it 'raise error api validation when amount is not in valid range' do
      VCR.use_cassette('xendit_api/api/qr_codes/error_not_valid_range') do
        error_payload = { 'error_code' => 'API_VALIDATION_ERROR', 'message' => 'Amount must be within range [1500, 5000000]' }
        qr_code = described_class.new(client)
        params = {
          external_id: 'sample-qr-code-123',
          type: 'DYNAMIC',
          callback_url: 'https://webhook.site/cc1e188a-cd5a-4a7e-b7f9-413a2289b580',
          amount: 50_000_000
        }
        expect do
          qr_code.create(params)
        end.to raise_error do |error|
          expect(error).to be_kind_of XenditApi::Errors::ApiValidation
          expect(error.message).to eq 'Validation error'
          expect(error.payload).to eq error_payload
        end
      end
    end
  end

  describe '#find' do
    it 'returns expected response when find by external_id' do
      VCR.use_cassette('xendit_api/api/qr_codes/find_valid') do
        qr_code = described_class.new(client)
        response = qr_code.find('sample-qr-code')
        expect(response).to be_instance_of XenditApi::Model::QrCode
        expect(response.id).to eq 'qr_0c5dab3c-eaac-4348-bb43-4e4884425dd8'
        expect(response.external_id).to eq 'sample-qr-code'
        expect(response.amount).to eq 100_000
        expect(response.description).to eq ''
        expect(response.qr_string).to eq 'mock-QR-string-use-simulate-payment-to-test-flow'
        expect(response.callback_url).to eq 'https://webhook.site/cc1e188a-cd5a-4a7e-b7f9-413a2289b580'
        expect(response.type).to eq 'DYNAMIC'
        expect(response.status).to eq 'ACTIVE'
        expect(response.created).to eq '2021-09-07T06:37:28.827Z'
        expect(response.updated).to eq '2021-09-07T06:37:28.827Z'
        expect(response.metadata).to eq nil
        expect(response.payload).not_to eq nil
        expect(response.request_id).to eq '835390137024978881'
      end
    end

    it 'raise not found when find by vendorable_id' do
      VCR.use_cassette('xendit_api/api/qr_codes/not_found') do
        expect do
          qr_code = described_class.new(client)
          qr_code.find('qr_0c5dab3c-eaac-4348-bb43-4e4884425dd8')
        end.to raise_error XenditApi::Errors::DataNotFound
      end
    end
  end

  describe '#find_payments' do
    it 'returns expected response' do
      VCR.use_cassette('xendit_api/api/qr_codes/payments') do
        qr_code = described_class.new(client)
        payments = qr_code.find_payments('sample-qr-code')
        expect(payments.size).to eq 1
        payment = payments.last
        expect(payment).to be_instance_of XenditApi::Model::QrCodePayment
        expect(payment.qr_code).to be_instance_of XenditApi::Model::QrCode
        expect(payment.payload).not_to eq nil
        expect(payment.id).to eq 'qrpy_dd3591a4-3dda-4b96-bd82-d3fc05e1a902'
        expect(payment.amount).to eq 100_000
        expect(payment.created).to eq '2021-09-07T08:40:52.876Z'
        expect(payment.status).to eq 'COMPLETED'
        expect(payment.request_id).to eq '835390137024978881'
      end
    end

    it 'returns expected when payment was blank' do
      VCR.use_cassette('xendit_api/api/qr_codes/blank_payments') do
        qr_code = described_class.new(client)
        payments = qr_code.find_payments('sample-qr-code-valid')
        expect(payments).to eq []
      end
    end

    it 'raise error when find payments with invalid external-id' do
      VCR.use_cassette('xendit_api/api/qr_codes/not_found_data_99999') do
        qr_code = described_class.new(client)
        payments = qr_code.find_payments('not_found_data_99999')
        expect(payments).to eq []
      end
    end
  end
end
