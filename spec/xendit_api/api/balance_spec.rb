require 'spec_helper'
require 'xendit_api/model/account_type'

RSpec.describe XenditApi::Api::Balance do
  let(:client) { XenditApi::Client.new('FILTERED_AUTH_KEY') }

  describe '#get' do
    it 'returns cash balance as default' do
      VCR.use_cassette('xendit/balance/get/success_cash') do
        balance_api = described_class.new(client)
        response = balance_api.get

        expect(response).not_to be_nil
        expect(response.balance).to eq 1_000_000_000
        expect(response.request_id).to eq '8353901370249765966'
      end
    end

    it 'returns cash balance when account type is passed on the arg' do
      VCR.use_cassette('xendit/balance/get/success_cash_arg') do
        balance_api = described_class.new(client)
        response = balance_api.get(XenditApi::Model::AccountType::CASH)

        expect(response).not_to be_nil
        expect(response.balance).to eq 1_000_000_000
        expect(response.request_id).to eq '4926327090049152759'
      end
    end

    it 'returns holding balance when account type is passed on the arg' do
      VCR.use_cassette('xendit/balance/get/success_holding_arg') do
        balance_api = described_class.new(client)
        response = balance_api.get(XenditApi::Model::AccountType::HOLDING)

        expect(response).not_to be_nil
        expect(response.balance).to eq 100_000
        expect(response.request_id).to eq '3948172116085043672'
      end
    end

    it 'returns tax balance when account type is passed on the arg' do
      VCR.use_cassette('xendit/balance/get/success_tax_arg') do
        balance_api = described_class.new(client)
        response = balance_api.get(XenditApi::Model::AccountType::TAX)

        expect(response).not_to be_nil
        expect(response.balance).to eq 200_000
        expect(response.request_id).to eq '2745410957596909051'
      end
    end
  end
end
