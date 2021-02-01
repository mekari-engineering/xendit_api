require 'spec_helper'
require 'xendit_api/api/disbursement'
require 'xendit_api/client'
require 'xendit_api/errors/disbursement'
require 'securerandom'

RSpec.describe XenditApi::Api::Disbursement do
  let(:client) { XenditApi::Client.new }

  describe '#create' do
    context 'with valid params' do
      it 'returns expected response' do
        VCR.use_cassette('xendit/disbursement/create/success') do
          disbursement_api = described_class.new(client)
          response = disbursement_api.create(
            external_id: SecureRandom.uuid,
            amount: 15_000,
            bank_code: 'BCA',
            account_holder_name: 'Bob Jones',
            account_number: '1111111111',
            disbursement_description: 'Payment'
          )
          expect(response).to be_instance_of XenditApi::Model::Disbursement
          expect(response).to have_attributes(
            amount: 15_000,
            bank_code: 'BCA',
            account_holder_name: 'Bob Jones',
            status: 'PENDING',
            disbursement_description: 'sample disbursement'
          )
          expect(response.external_id).not_to be_nil
          expect(response.id).not_to be_nil
        end
      end
    end

    context 'with invalid params' do
      it 'raise errors when bank code not registered' do
        VCR.use_cassette('xendit/disbursement/create/bank_code_not_supported_error') do
          disbursement_api = described_class.new(client)
          expect do
            disbursement_api.create(
              external_id: SecureRandom.uuid,
              amount: 15_000,
              bank_code: 'NOT_FOUND',
              account_holder_name: 'Bob Jones',
              account_number: '1111111111',
              disbursement_description: 'sample disbursement'
            )
          end.to raise_error XenditApi::Errors::Disbursement::BankCodeNotSupported, 'Bank code is not supported'
        end
      end

      it 'raise errors when got DISBURSEMENT_DESCRIPTION_NOT_FOUND_ERROR' do
        VCR.use_cassette('xendit/disbursement/create/disbursement_description_not_found_error') do
          disbursement_api = described_class.new(client)
          expect do
            disbursement_api.create(
              external_id: SecureRandom.uuid,
              amount: 15_000,
              bank_code: 'BCA',
              account_holder_name: 'Bob Jones',
              account_number: '1111111111',
              disbursement_description: nil
            )
          end.to raise_error XenditApi::Errors::Disbursement::DescriptionNotFound
        end
      end

      it 'raise errors when got DIRECT_DISBURSEMENT_BALANCE_INSUFFICIENT_ERROR' do
        VCR.use_cassette('xendit/disbursement/create/disbursement_not_enough_balance_error') do
          disbursement_api = described_class.new(client)
          expect do
            disbursement_api.create(
              external_id: SecureRandom.uuid,
              amount: 1_000_000_000_000,
              bank_code: 'BCA',
              account_holder_name: 'Bob Jones',
              account_number: '1111111111',
              disbursement_description: 'sample disbursement'
            )
          end.to raise_error XenditApi::Errors::Disbursement::NotEnoughBalance
        end
      end

      it 'raise erorrs when got DUPLICATE_TRANSACTION_ERROR' do
        VCR.use_cassette('xendit/disbursement/create/duplicate_transaction_error') do
          disbursement_api = described_class.new(client)
          expect do
            disbursement_api.create(
              external_id: SecureRandom.uuid,
              amount: 100_000,
              bank_code: 'BCA',
              account_holder_name: 'Bob Jones',
              account_number: '1111111111',
              disbursement_description: 'sample disbursement'
            )
          end.to raise_error XenditApi::Errors::Disbursement::DuplicateTransactionError
        end
      end

      it 'raise error when got RECIPIENT_ACCOUNT_NUMBER_ERROR' do
        VCR.use_cassette('xendit/disbursement/create/recipient_account_number_error') do
          disbursement_api = described_class.new(client)
          expect do
            disbursement_api.create(
              external_id: SecureRandom.uuid,
              amount: 100_000,
              bank_code: 'BCA',
              account_holder_name: 'Bob Jones',
              account_number: '123',
              disbursement_description: 'sample disbursement'
            )
          end.to raise_error XenditApi::Errors::Disbursement::RecipientAccountNumberError
        end
      end

      it 'raise error when got RECIPIENT_AMOUNT_ERROR' do
        VCR.use_cassette('xendit/disbursement/create/recipient_amount_error') do
          disbursement_api = described_class.new(client)
          expect do
            disbursement_api.create(
              external_id: SecureRandom.uuid,
              amount: 1,
              bank_code: 'BCA',
              account_holder_name: 'Bob Jones',
              account_number: '1111111111',
              disbursement_description: 'sample disbursement'
            )
          end.to raise_error XenditApi::Errors::Disbursement::RecipientAmountError
        end
      end

      it 'raise error when got MAXIMUM_TRANSFER_LIMIT_ERROR' do
        VCR.use_cassette('xendit/disbursement/create/maximum_transfer_limit_error') do
          disbursement_api = described_class.new(client)
          expect do
            disbursement_api.create(
              external_id: SecureRandom.uuid,
              amount: 10_000_000,
              bank_code: 'BCA',
              account_holder_name: 'Bob Jones',
              account_number: '1111111111',
              disbursement_description: 'sample disbursement'
            )
          end.to raise_error XenditApi::Errors::Disbursement::MaximumTransferLimitError
        end
      end
    end
  end

  # describe '#find_by_external_id' do
  #   context 'with invalid external id' do
  #     it 'returns expected response' do
  #       VCR.use_cassette('xendit/disbursement/find_by_external_id/invalid') do
  #         disbursement_api = described_class.new(client)

  #         expect do
  #           disbursement_api.find_by_external_id('666')
  #         end.to raise_error XenditApi::Errors::Disbursement::MaximumTransferLimitError
  #       end
  #     end
  #   end
  # end
end
