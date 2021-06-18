require 'spec_helper'
require 'xendit_api/errors/ovo'

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

  describe '#post' do
    context 'with valid params' do
      let(:params) do
        {
          reference_id: 'nobu@mekari.com',
          amount: 1_000,
          mobile_number: '+6281234567890',
          channel_code: 'ID_OVO'
        }
      end

      it 'returns expected response' do
        VCR.use_cassette('xendit/ewallet/ovo/success') do
          client = described_class.new(auth_key)
          response = client.post('/ewallets/charges', params)
          expect(response).to include({
                                        'created' => '2021-06-17T03:26:11.253Z',
                                        'capture_amount' => 1000,
                                        'charge_amount' => 1000,
                                        'reference_id' => 'nobu@mekari.com',
                                        'channel_code' => 'ID_OVO',
                                        'business_id' => '12121212'
                                      })
        end
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          reference_id: 'nuba@mekari.com',
          amount: 1_000,
          mobile_number: '0',
          channel_code: 'ID_OVO'
        }
      end

      it 'returns error response' do
        VCR.use_cassette('xendit/ewallet/ovo/errors_invalid_phone_number') do
          expect do
            client = described_class.new(auth_key)
            client.post('/ewallets/charges', params)
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
        id = 'ewc_b66bb767-be7e-4247-8a75-2a970a749e46'
        response = client.get("/ewallets/charges/#{id}")
        expect(response).to include({
                                      'capture_amount' => 1_000,
                                      'charge_amount' => 1_000,
                                      'reference_id' => 'nobu@mekari.com',
                                      'created' => '2021-06-17T03:26:11.253Z',
                                      'business_id' => '12121212',
                                      'channel_code' => 'ID_OVO',
                                      'status' => 'SUCCEEDED'
                                    })
      end
    end

    it 'returns payment not found' do
      VCR.use_cassette('xendit/ewallet/ovo/get_payment_not_found') do
        expect do
          client = described_class.new(auth_key)
          random_uuid = 'ewc_d351c488-fd5c-4a41-975f-f94614f7628f'
          client.get("/ewallets/charges/#{random_uuid}")
        end.to raise_error(XenditApi::Errors::OVO::PaymentNotFound)
      end
    end
  end
end
