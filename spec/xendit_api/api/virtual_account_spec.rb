require 'spec_helper'
require 'xendit_api/api/virtual_account'
require 'xendit_api/client'
require 'xendit_api/errors/virtual_account'

RSpec.describe XenditApi::Api::VirtualAccount do
  let(:client) { XenditApi::Client.new }

  describe '#find' do
    it 'returns expected response when find virtual account by Mandiri bank' do
      fake_time = DateTime.new(2020, 5, 5)
      stub_time_now_to(fake_time)
      virtual_account_api = described_class.new(client)
      VCR.use_cassette('xendit/virtual_account/find_virtual_account_mandiri_success') do
        recorded_virtual_account_id = '5e61d90539334c3592100a91'
        virtual_account = virtual_account_api.find(recorded_virtual_account_id)
        expect(virtual_account).to have_attributes(
          id: recorded_virtual_account_id,
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          status: 'ACTIVE',
          bank_code: 'MANDIRI',
          is_closed: true,
          is_single_use: true
        )
        expect(virtual_account.merchant_code).not_to be_nil
        expect(virtual_account.account_number).not_to be_nil
        expect(find_year(virtual_account.expiration_date)).to eq fake_time.year + 31
      end
    end

    it 'returns expected response when find virtual account by BRI bank' do
      fake_time = DateTime.new(2020, 5, 5)
      stub_time_now_to(fake_time)
      virtual_account_api = described_class.new(client)
      VCR.use_cassette('xendit/virtual_account/find_virtual_account_bri_success') do
        recorded_virtual_account_id = '5e61e9c77f26b138b0580d89'
        virtual_account = virtual_account_api.find(recorded_virtual_account_id)
        expect(virtual_account).to have_attributes(
          id: recorded_virtual_account_id,
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          status: 'PENDING',
          bank_code: 'BRI',
          is_closed: true,
          is_single_use: true
        )
        expect(virtual_account.merchant_code).not_to be_nil
        expect(virtual_account.account_number).not_to be_nil
        expect(find_year(virtual_account.expiration_date)).to eq fake_time.year + 31
      end
    end

    it 'returns expected response when find virtual account by BNI bank' do
      fake_time = DateTime.new(2020, 5, 5)
      stub_time_now_to(fake_time)
      virtual_account_api = described_class.new(client)
      VCR.use_cassette('xendit/virtual_account/find_virtual_account_bni_success') do
        recorded_virtual_account_id = '5e61eaa339334c3592100a9e'
        virtual_account = virtual_account_api.find(recorded_virtual_account_id)
        expect(virtual_account).to have_attributes(
          id: recorded_virtual_account_id,
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          status: 'PENDING',
          bank_code: 'BNI',
          is_closed: true
        )
        expect(virtual_account.merchant_code).not_to be_nil
        expect(virtual_account.account_number).not_to be_nil
        expect(find_year(virtual_account.expiration_date)).to eq fake_time.year + 31
      end
    end

    it 'raise CALLBACK_VIRTUAL_ACCOUNT_NOT_FOUND_ERROR when virtual account data was not found' do
      virtual_account_api = described_class.new(client)
      not_found_virtual_account_id = '99999999999'
      VCR.use_cassette('xendit/virtual_account/callback_not_found_error') do
        expect do
          virtual_account_api.find(not_found_virtual_account_id)
        end.to raise_error XenditApi::Errors::VirtualAccount::CallbackNotFound
      end
    end
  end

  describe '#create' do
    it 'returns success response with mandiri bank code' do
      fake_time = DateTime.new(2020, 5, 5)
      stub_time_now_to(fake_time)
      VCR.use_cassette('xendit/virtual_account/mandiri_success') do
        virtual_account_api = described_class.new(client)
        response = virtual_account_api.create(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          amount: 500_000,
          bank_code: 'MANDIRI'
        )
        expect(response).to be_instance_of XenditApi::Model::VirtualAccount
        expect(response.id).not_to be_nil
        expect(response.account_number).not_to be_nil
        expect(response.merchant_code).not_to be_nil
        expect(response.owner_id).not_to be_nil
        expect(find_year(response.expiration_date)).to eq fake_time.year + 31
        expect(response).to have_attributes(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          bank_code: 'MANDIRI',
          suggested_amount: 500_000,
          expected_amount: 500_000,
          is_closed: true,
          is_single_use: true,
          currency: 'IDR',
          status: 'PENDING'
        )
      end
    end

    it 'returns success response with mandiri bank code but has new attribute' do
      fake_time = DateTime.new(2020, 5, 5)
      stub_time_now_to(fake_time)
      VCR.use_cassette('xendit/virtual_account/mandiri_success_with_new_attribute') do
        virtual_account_api = described_class.new(client)
        response = virtual_account_api.create(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          amount: 500_000,
          bank_code: 'MANDIRI'
        )
        expect(response).to be_instance_of XenditApi::Model::VirtualAccount
        expect(response.id).not_to be_nil
        expect(response.account_number).not_to be_nil
        expect(response.merchant_code).not_to be_nil
        expect(response.owner_id).not_to be_nil
        expect(find_year(response.expiration_date)).to eq fake_time.year + 31
        expect(response).to have_attributes(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          bank_code: 'MANDIRI',
          suggested_amount: 500_000,
          expected_amount: 500_000,
          is_closed: true,
          is_single_use: true,
          currency: 'IDR',
          status: 'PENDING'
        )
      end
    end

    it 'returns success response with mandiri bank code but has removed attribute' do
      fake_time = DateTime.new(2020, 5, 5)
      stub_time_now_to(fake_time)
      VCR.use_cassette('xendit/virtual_account/mandiri_success_with_removed_attribute') do
        virtual_account_api = described_class.new(client)
        response = virtual_account_api.create(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          amount: 500_000,
          bank_code: 'MANDIRI'
        )
        expect(response).to be_instance_of XenditApi::Model::VirtualAccount
        expect(response.id).not_to be_nil
        expect(response.account_number).not_to be_nil
        expect(response.merchant_code).to be_nil
        expect(response.owner_id).not_to be_nil
        expect(find_year(response.expiration_date)).to eq fake_time.year + 31
        expect(response).to have_attributes(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          bank_code: 'MANDIRI',
          suggested_amount: 500_000,
          expected_amount: 500_000,
          is_closed: true,
          is_single_use: true,
          currency: 'IDR',
          status: 'PENDING'
        )
      end
    end

    it 'returns expected response with BNI bank code' do
      fake_time = DateTime.new(2020, 5, 5)
      stub_time_now_to(fake_time)
      VCR.use_cassette('xendit/virtual_account/bni_success') do
        virtual_account_api = described_class.new(client)
        response = virtual_account_api.create(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          amount: 500_000,
          bank_code: 'BNI'
        )
        expect(response).to be_instance_of XenditApi::Model::VirtualAccount
        expect(response.id).not_to be_nil
        expect(response.account_number).not_to be_nil
        expect(response.merchant_code).not_to be_nil
        expect(response.owner_id).not_to be_nil
        # is_single_use not supported in BNI yet.
        expect(response.is_single_use).to eq false
        expect(find_year(response.expiration_date)).to eq fake_time.year + 31
        expect(response).to have_attributes(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          bank_code: 'BNI',
          expected_amount: 500_000,
          is_closed: true,
          currency: 'IDR',
          status: 'PENDING'
        )
      end
    end

    it 'returns expected response with BRI bank code' do
      fake_time = DateTime.new(2020, 5, 5)
      stub_time_now_to(fake_time)
      VCR.use_cassette('xendit/virtual_account/bri_success') do
        virtual_account_api = described_class.new(client)
        response = virtual_account_api.create(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          amount: 500_000,
          bank_code: 'BRI'
        )
        expect(response).to be_instance_of XenditApi::Model::VirtualAccount
        expect(response.id).not_to be_nil
        expect(response.account_number).not_to be_nil
        expect(response.merchant_code).not_to be_nil
        expect(response.owner_id).not_to be_nil
        expect(find_year(response.expiration_date)).to eq fake_time.year + 31
        expect(response).to have_attributes(
          external_id: 'sample-mandiri-demo',
          name: 'Nobu nagawa',
          bank_code: 'BRI',
          suggested_amount: 500_000,
          expected_amount: 500_000,
          is_closed: true,
          is_single_use: true,
          currency: 'IDR',
          status: 'PENDING'
        )
      end
    end

    it 'raise BANK_NOT_SUPPORTED_ERROR with unknown bank code' do
      VCR.use_cassette('xendit/virtual_account/raise_bank_not_supported') do
        virtual_account_api = described_class.new(client)
        expect do
          virtual_account_api.create(
            external_id: 'sample-mandiri-demo',
            name: 'Nobu nagawa',
            amount: 500_000,
            bank_code: 'RANDOM_BANK_CODE'
          )
        end.to raise_error XenditApi::Errors::VirtualAccount::BankNotSupported
      end
    end

    it 'raises API_VALIDATION_ERROR when external_id, name, amount was blank' do
      VCR.use_cassette('xendit/virtual_account/raise_api_validation') do
        virtual_account_api = described_class.new(client)
        expect do
          virtual_account_api.create(
            external_id: nil,
            name: nil,
            amount: nil,
            bank_code: 'MANDIRI'
          )
        end.to raise_error XenditApi::Errors::ApiValidation
      end
    end

    it 'raises MINIMUM_EXPECTED_AMOUNT_ERROR when amount was 0' do
      VCR.use_cassette('xendit/virtual_account/raise_minimum_amount_error') do
        virtual_account_api = described_class.new(client)
        expect do
          virtual_account_api.create(
            external_id: 'sample-mandiri-demo',
            name: 'Nobu nagawa',
            amount: 0,
            bank_code: 'MANDIRI'
          )
        end.to raise_error XenditApi::Errors::VirtualAccount::MinimumExpectedAmount
      end
    end

    it 'raises MAXIMUM_EXPECTED_AMOUNT_ERROR when amount was larger than 50_000_000_000' do
      VCR.use_cassette('xendit/virtual_account/raise_maximum_amount_error') do
        virtual_account_api = described_class.new(client)
        expect do
          virtual_account_api.create(
            external_id: 'sample-mandiri-demo',
            name: 'Nobu nagawa',
            amount: 50_000_000_001,
            bank_code: 'MANDIRI'
          )
        end.to raise_error XenditApi::Errors::VirtualAccount::MaximumExpectedAmount
      end
    end
  end

  describe '#update_to_expired' do
    it 'returns updated virtual account' do
      fake_time = DateTime.new(2020, 5, 5)
      stub_time_now_to(fake_time)
      virtual_account_api = described_class.new(client)
      VCR.use_cassette('xendit/virtual_account/update_virtual_account_to_expired') do
        VCR.use_cassette('xendit/virtual_account/update_virtual_account_to_expired_2') do
          create_response = virtual_account_api.create(
            external_id: 'sample-mandiri-demo',
            name: 'Nobu nagawa',
            amount: 500_000,
            bank_code: 'MANDIRI'
          )
          expect(find_year(create_response.expiration_date)).to eq fake_time.year + 31
          update_response = virtual_account_api.update_to_expired(create_response.id)
          expect(find_year(update_response.expiration_date)).to eq fake_time.year - 1
        end
      end
    end
  end

  private

  def stub_time_now_to(fake_time)
    allow(Time).to receive_messages(now: fake_time)
  end

  def find_year(date_string)
    DateTime.parse(date_string).year
  end
end
