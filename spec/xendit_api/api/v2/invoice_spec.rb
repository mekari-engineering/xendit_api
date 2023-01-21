require 'spec_helper'
require 'xendit_api/api/v2/invoice'
require 'xendit_api/errors/v2/invoice'
require 'xendit_api/client'

RSpec.describe XenditApi::Api::V2::Invoice do
  let(:client) { XenditApi::Client.new('xnd_development_R4CCrL94lhsCWd1PTiaekgOcHznim1bUnwL7je48hVW8gv33Ot7azgk4DbB5VEmS') }
  let(:invoice_api) { described_class.new(client) }

  describe '#post' do
    context 'with valid params' do
      let(:params) do
        {
          external_id: 'eacd7788-8864-421c-a39c-9c59c3ee875c',
          amount: 100_000
        }
      end

      it 'returns success response' do
        VCR.use_cassette('xendit/v2/invoice/success') do
          response = invoice_api.post(params: params)

          expect(response).to be_instance_of XenditApi::Model::V2::Invoice
          expect(response.external_id).to eq 'eacd7788-8864-421c-a39c-9c59c3ee875c'
          expect(response.amount).to eq 100_000
        end
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          external_id: nil,
          amount: 100_000
        }
      end

      it 'raise error xendit validation' do
        VCR.use_cassette('xendit/v2/invoice/external_id_nil') do
          expect do
            invoice_api.post(params: params)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::ApiValidation
            expect(error.message).to eq 'Validation error'
          end
        end
      end
    end
  end

  describe '#get' do
    context 'when successfully return invoice detail by ID' do
      it 'returns expected response' do
        VCR.use_cassette('xendit/v2/invoice/get') do
          id = '63c9dadfbc62165502c6e8cd'
          response = invoice_api.get(id)

          expect(response).to be_instance_of XenditApi::Model::V2::Invoice
          expect(response.paid_amount).to eq 91_000
          expect(response.id).to eq id
        end
      end
    end

    context 'when payment not found' do
      it 'returns error response' do
        VCR.use_cassette('xendit/v2/invoice/get_payment_not_found') do
          expect do
            random_id = '6e86bc62165502ccd3c9dadf'
            invoice_api.get(random_id)
          end.to raise_error do |error|
            expect(error).to be_kind_of XenditApi::Errors::UnknownError
            expect(error.message).to eq 'Could not find invoice by id 6e86bc62165502ccd3c9dadf'
          end
        end
      end
    end
  end

  pending '#get_by_external_id'
end
