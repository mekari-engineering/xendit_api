require 'spec_helper'

RSpec.describe XenditApi::Api::Report do
  let(:client) { XenditApi::Client.new("xnd_development_AOQryoQ1J5SzSFzMEJ24sYqWUDucDfeKVzjIbtegLYK7t1YsBw4JMm9H9LHvm") }

  describe '#create' do
    it 'returns expected response' do
      VCR.use_cassette('xendit/report/create/success') do
        report_api = described_class.new(client)  
        response  = report_api.create(
          type: "BALANCE_HISTORY"
        )
        expect(response).to be_instance_of XenditApi::Model::Report
      end
    end
  end
end