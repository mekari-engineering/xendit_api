require 'spec_helper'
require 'xendit_api/model/ewallet'

RSpec.describe XenditApi::Model::Ewallet do
  it 'returns expected attributes' do
    ewallet_response = described_class.new(
      transaction_date: '2019-04-07T01:35:46.658Z',
      amount: 1000,
      external_id: 'nobu@mekari.com',
      ewallet_type: 'OVO',
      business_id: '121212',
      status: 'COMPLETED'
    )
    expect(ewallet_response.transaction_date).to eq '2019-04-07T01:35:46.658Z'
    expect(ewallet_response.amount).to eq 1000
    expect(ewallet_response.external_id).to eq 'nobu@mekari.com'
    expect(ewallet_response.ewallet_type).to eq 'OVO'
    expect(ewallet_response.business_id).to eq '121212'
    expect(ewallet_response.status).to eq 'COMPLETED'
  end

  it 'returns nil as default value' do
    ewallet_response = described_class.new
    expect(ewallet_response.transaction_date).to be nil
    expect(ewallet_response.amount).to be nil
    expect(ewallet_response.external_id).to be nil
    expect(ewallet_response.ewallet_type).to be nil
    expect(ewallet_response.business_id).to be nil
    expect(ewallet_response.status).to be nil
  end
end
