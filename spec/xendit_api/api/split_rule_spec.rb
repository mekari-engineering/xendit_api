require 'spec_helper'

RSpec.describe XenditApi::Api::SplitRule do
  let(:client) { XenditApi::Client.new('FILTERED_AUTH_KEY') }
  let(:split_rule_api) { described_class.new(client) }

  describe 'PATH constant' do
    it 'has the correct path' do
      expect(described_class::PATH).to eq('/split_rules')
    end
  end

  describe 'inheritance' do
    it 'inherits from Base' do
      expect(described_class.superclass).to eq(XenditApi::Api::Base)
    end
  end

  describe '#create' do
    let(:params) do
      {
        name: 'Test Split Rule',
        description: 'A test split rule',
        routes: [
          {
            flat_amount: 1000,
            currency: 'IDR',
            destination: {
              type: 'MERCHANT',
              account_code: 'MERCHANT_001'
            }
          }
        ]
      }
    end

    let(:expected_response) do
      {
        id: 'sr_123456789',
        name: 'Test Split Rule',
        description: 'A test split rule',
        created: '2023-10-08T10:00:00.000Z',
        updated: '2023-10-08T10:00:00.000Z',
        routes: [
          {
            flat_amount: 1000,
            currency: 'IDR',
            destination: {
              type: 'MERCHANT',
              account_code: 'MERCHANT_001'
            }
          }
        ]
      }
    end

    it 'creates a split rule and returns a SplitRule model' do
      allow(client).to receive(:post).with('/split_rules', params, { 'Path-Group' => '/split_rules' })
                                     .and_return(expected_response)

      result = split_rule_api.create(params)

      expect(result).to be_a(XenditApi::Model::SplitRule)
      expect(result.id).to eq('sr_123456789')
      expect(result.name).to eq('Test Split Rule')
      expect(result.description).to eq('A test split rule')
    end

    it 'sends correct headers with Path-Group' do
      allow(client).to receive(:post).and_return(expected_response)

      split_rule_api.create(params)

      expect(client).to have_received(:post).with(
        '/split_rules',
        params,
        { 'Path-Group' => '/split_rules' }
      )
    end

    it 'passes through the correct parameters' do
      allow(client).to receive(:post).and_return(expected_response)

      split_rule_api.create(params)

      expect(client).to have_received(:post).with('/split_rules', params, anything)
    end

    context 'when client raises an error' do
      it 'propagates the error' do
        allow(client).to receive(:post).and_raise(StandardError, 'Network error')

        expect { split_rule_api.create(params) }.to raise_error(StandardError, 'Network error')
      end
    end
  end

  describe '#initialize' do
    it 'accepts a client parameter' do
      expect(split_rule_api.client).to eq(client)
    end
  end
end
