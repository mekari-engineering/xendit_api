require 'spec_helper'

RSpec.describe XenditApi::Client do
  let(:auth_key) { 'FILTERED_AUTH_KEY' }

  it 'retur ns expected base url' do
    expect(XenditApi::Client::BASE_URL).to eq 'https://api.xendit.co'
  end

  describe '#ewallet' do
    it 'returns instance of XenditApi::Api::Ewallet' do
      client = described_class.new(auth_key)
      expect(client.ewallet).to be_instance_of XenditApi::Api::Ewallet
    end
  end

  describe '#virtual_account' do
    it 'returns instance of XenditApi::Api::VirtualAccount' do
      client = described_class.new(auth_key)
      expect(client.virtual_account).to be_instance_of XenditApi::Api::VirtualAccount
    end
  end

  describe '#credit_card' do
    it 'returns instance of XenditApi::Api::CreditCard' do
      client = described_class.new(auth_key)
      expect(client.credit_card).to be_instance_of XenditApi::Api::CreditCard
    end
  end

  describe '#disbursement' do
    it 'returns instance of XenditApi::Api::Disbursement' do
      client = described_class.new(auth_key)
      expect(client.disbursement).to be_instance_of XenditApi::Api::Disbursement
    end
  end

  describe '#v1_ewallet' do
    it 'returns instance of XenditApi::Api::Ewallet' do
      client = described_class.new(auth_key)
      expect(client.v1_ewallet).to be_instance_of XenditApi::Api::V1::Ewallet
    end
  end

  describe '#post' do
    context 'with valid params' do
      let(:params) do
        {
          external_id: 'nobu@mekari.com',
          amount: 1_000,
          phone: '081234567890',
          ewallet_type: 'OVO'
        }
      end

      it 'returns expected response' do
        VCR.use_cassette('xendit/ewallet/ovo/success') do
          client = described_class.new(auth_key)
          response = client.post('/ewallets', params)
          expect(response).to eq({
                                   'transaction_date' => '2019-04-07T01:35:46.658Z',
                                   'amount' => 1000,
                                   'external_id' => 'nobu@mekari.com',
                                   'ewallet_type' => 'OVO',
                                   'business_id' => '12121212'
                                 })
        end
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          external_id: 'nobu@mekari.com',
          amount: 1_000,
          phone: ''
        }
      end

      it 'returns error response' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_invalid_phone_number') do
          expect do
            client = described_class.new(auth_key)
            client.post('/ewallets', params)
            # FIXME
          end.to raise_error(XenditApi::Errors::ApiValidation)
        end
      end
    end
  end

  describe '#get' do
    it 'returns complete payment' do
      VCR.use_cassette('xendit/ewallet/ovo/get_complete_payment') do
        client = described_class.new(auth_key)
        response = client.get('/ewallets', external_id: '12345')
        expect(response).to eq({
                                 'amount' => 1_000,
                                 'external_id' => '12345',
                                 'transaction_date' => '2019-04-07T01:35:46.658Z',
                                 'business_id' => '12121212',
                                 'ewallet_type' => 'OVO',
                                 'status' => 'COMPLETED'
                               })
      end
    end

    it 'returns payment not found' do
      VCR.use_cassette('xendit/ewallet/ovo/get_payment_not_found') do
        expect do
          client = described_class.new(auth_key)
          client.get('/ewallets', external_id: nil)
        end.to raise_error(XenditApi::Errors::OVO::PaymentNotFound)
      end
    end
  end

  describe '#qr_code' do
    it 'returns expected instance' do
      client = described_class.new(auth_key)
      expect(client.qr_code).to be_instance_of XenditApi::Api::QrCode
    end
  end
end
