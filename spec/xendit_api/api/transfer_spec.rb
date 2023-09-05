require 'spec_helper'

RSpec.describe XenditApi::Api::Transfer do
  let(:client) { XenditApi::Client.new('FILTERED_AUTH_KEY') }

  describe '#find_by_reference' do
    it 'returns expected response' do
      VCR.use_cassette('xendit_api/api/transfer/find_by_reference') do
        transfer = described_class.new(client)
        response = transfer.find_by_reference('Automation-ref-1692074901')

        expect(response.reference).to eq('Automation-ref-1692074901')
      end
    end
  end
end
