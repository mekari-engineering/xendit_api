require 'spec_helper'

RSpec.describe XenditApi::Api::Report do
  let(:client) { XenditApi::Client.new }

  describe '#create' do
    it 'returns expected response' do
      VCR.use_cassette('xendit/report/create/success') do
        report_api = described_class.new(client)
        response = report_api.create(
          type: 'BALANCE_HISTORY'
        )
        expect(response).to be_instance_of XenditApi::Model::Report
      end
    end

    it 'return error invalid date range' do
      VCR.use_cassette('xendit/report/create/invalid_date_range') do
        report_api = described_class.new(client)
        params = {
          type: 'BALANCE_HISTORY',
          filter: {
            from: '2021-01-23T04:01:55.574Z',
            to: '2021-06-23T04:01:55.574Z'
          }
        }

        expect do
          report_api.create(params)
        end.to raise_error XenditApi::Errors::Report::InvalidDateRange
      end
    end

    it 'return error feature not available' do
      VCR.use_cassette('xendit/report/create/feature_not_available') do
        report_api = described_class.new(client)
        params = {
          type: 'BALANCE_HISTORY'
        }

        expect do
          report_api.create(params)
        end.to raise_error XenditApi::Errors::RequestForbidden
      end
    end
  end
end
