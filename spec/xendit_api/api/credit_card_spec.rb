require 'spec_helper'
require 'xendit_api/api/credit_card'
require 'securerandom'

RSpec.describe XenditApi::Api::CreditCard do
  let(:client) { XenditApi::Client.new }

  describe '#charge' do
    it 'returns expected credit card model' do
      api_charge = described_class.new(client)
      response = {
        'status' => 'CAPTURED',
        'authorized_amount' => 500_000,
        'capture_amount' => 500_000,
        'currency' => 'IDR',
        'credit_card_token_id' => '600a56e7e4d6190020220bc4',
        'business_id' => '596d988e56b5a3c45be75e6e',
        'merchant_id' => 'xendit_ctv_agg',
        'merchant_reference_code' => '600a56e6a1ba47c821f21830',
        'external_id' => 'e9035d73-4069-4235-8eea-7dd0eb614595',
        'eci' => '05',
        'charge_type' => 'SINGLE_USE_TOKEN',
        'masked_card_number' => '400000XXXXXX0002',
        'card_brand' => 'VISA',
        'card_type' => 'CREDIT',
        'xid' => 'S1lNYXFSMjZWQ1lGV21JUzRRUjA=',
        'cavv' => 'AAABAWFlmQAAAABjRWWZEEFgFz+=',
        'descriptor' => 'XENDIT*JURNAL',
        'authorization_id' => '600a56f7e4d6190020220bc6',
        'bank_reconciliation_id' => '6112903593156915303012',
        'cvn_code' => 'M',
        'approval_code' => '831000',
        'created' => '2021-01-22T04:39:20.001Z',
        'id' => '600a56f8e4d6190020220bc7'
      }
      params = {
        token: SecureRandom.hex,
        card_cvv: '123',
        external_id: SecureRandom.hex
      }
      stub_client_post_to(response)
      credit_card_response = api_charge.charge(params)
      expect(credit_card_response).to be_instance_of XenditApi::Model::CreditCard
    end

    it 'returns expected credit card model when there is removed attribute' do
      api_charge = described_class.new(client)
      response = {
        'status' => 'CAPTURED',
        'authorized_amount' => 500_000,
        'capture_amount' => 500_000,
        'currency' => 'IDR',
        'business_id' => '596d988e56b5a3c45be75e6e',
        'merchant_id' => 'xendit_ctv_agg',
        'merchant_reference_code' => '600a56e6a1ba47c821f21830',
        'external_id' => 'e9035d73-4069-4235-8eea-7dd0eb614595',
        'eci' => '05',
        'charge_type' => 'SINGLE_USE_TOKEN',
        'masked_card_number' => '400000XXXXXX0002',
        'card_brand' => 'VISA',
        'card_type' => 'CREDIT',
        'xid' => 'S1lNYXFSMjZWQ1lGV21JUzRRUjA=',
        'cavv' => 'AAABAWFlmQAAAABjRWWZEEFgFz+=',
        'descriptor' => 'XENDIT*JURNAL',
        'authorization_id' => '600a56f7e4d6190020220bc6',
        'bank_reconciliation_id' => '6112903593156915303012',
        'cvn_code' => 'M',
        'approval_code' => '831000',
        'created' => '2021-01-22T04:39:20.001Z',
        'id' => '600a56f8e4d6190020220bc7'
      }
      params = {
        token: SecureRandom.hex,
        card_cvv: '123',
        external_id: SecureRandom.hex
      }
      stub_client_post_to(response)
      credit_card_response = api_charge.charge(params)
      expect(credit_card_response).to be_instance_of XenditApi::Model::CreditCard
      expect(credit_card_response.status).to eq 'CAPTURED'
    end

    it 'returns expected credit card model when there is new attribute' do
      api_charge = described_class.new(client)
      response = {
        'status' => 'CAPTURED',
        'authorized_amount' => 500_000,
        'capture_amount' => 500_000,
        'currency' => 'IDR',
        'business_id' => '596d988e56b5a3c45be75e6e',
        'merchant_id' => 'xendit_ctv_agg',
        'merchant_reference_code' => '600a56e6a1ba47c821f21830',
        'external_id' => 'e9035d73-4069-4235-8eea-7dd0eb614595',
        'eci' => '05',
        'charge_type' => 'SINGLE_USE_TOKEN',
        'masked_card_number' => '400000XXXXXX0002',
        'card_brand' => 'VISA',
        'card_type' => 'CREDIT',
        'xid' => 'S1lNYXFSMjZWQ1lGV21JUzRRUjA=',
        'cavv' => 'AAABAWFlmQAAAABjRWWZEEFgFz+=',
        'descriptor' => 'XENDIT*JURNAL',
        'authorization_id' => '600a56f7e4d6190020220bc6',
        'bank_reconciliation_id' => '6112903593156915303012',
        'cvn_code' => 'M',
        'approval_code' => '831000',
        'created' => '2021-01-22T04:39:20.001Z',
        'id' => '600a56f8e4d6190020220bc7',
        'new_attribute' => 'Hello, world!'
      }
      params = {
        token: SecureRandom.hex,
        card_cvv: '123',
        external_id: SecureRandom.hex
      }
      stub_client_post_to(response)
      credit_card_response = api_charge.charge(params)
      expect(credit_card_response).to be_instance_of XenditApi::Model::CreditCard
      expect(credit_card_response.status).to eq 'CAPTURED'
    end
  end

  private

  def stub_client_post_to(response)
    allow_any_instance_of(XenditApi::Client).to receive(:post).and_return(response)
  end
end
