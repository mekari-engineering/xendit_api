require 'spec_helper'
require 'xendit_api/api/v2/account'
require 'xendit_api/client'

RSpec.describe XenditApi::Api::V2::Account do
  let(:client) { XenditApi::Client.new('FILTERED_AUTH_KEY') }
  let(:account_api) { described_class.new(client) }

  describe '#find' do
    context 'when successfully return account detail by ID' do
      it 'returns expected response' do
        VCR.use_cassette('xendit/v2/account/find') do
          id = '6395b67e1d1c372abc34bde8'
          response = account_api.find(id)

          expect(response).to be_instance_of XenditApi::Model::V2::Account
          expect(response.id).to eq id
        end
      end
    end

    context 'when account not found' do
      it 'returns error response' do
        VCR.use_cassette('xendit/v2/account/find_not_found') do
          expect do
            random_id = '6395b67e1d1c372abc34bde9'
            account_api.find(random_id)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::DataNotFound
            expect(error.message).to eq 'Account with this ID does not exist on your Platform.'
          end
        end
      end
    end
  end
end
