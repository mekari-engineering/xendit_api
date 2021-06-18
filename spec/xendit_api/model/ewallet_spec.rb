require 'spec_helper'
require 'xendit_api/model/ewallet'

RSpec.describe XenditApi::Model::Ewallet do
  it 'returns expected attributes' do
    ewallet_response = described_class.new(
      created: '2019-04-07T01:35:46.658Z',
      charge_amount: 1000,
      capture_amount: 1000,
      reference_id: 'nobu@mekari.com',
      channel_code: 'ID_OVO',
      business_id: '121212',
      status: 'SUCCEEDED'
    )
    expect(ewallet_response.created).to eq '2019-04-07T01:35:46.658Z'
    expect(ewallet_response.charge_amount).to eq 1000
    expect(ewallet_response.capture_amount).to eq 1000
    expect(ewallet_response.reference_id).to eq 'nobu@mekari.com'
    expect(ewallet_response.channel_code).to eq 'ID_OVO'
    expect(ewallet_response.business_id).to eq '121212'
    expect(ewallet_response.status).to eq 'SUCCEEDED'
  end

  it 'returns nil as default value' do
    ewallet_response = described_class.new
    expect(ewallet_response.created).to eq nil
    expect(ewallet_response.charge_amount).to eq nil
    expect(ewallet_response.capture_amount).to eq nil
    expect(ewallet_response.reference_id).to eq nil
    expect(ewallet_response.channel_code).to eq nil
    expect(ewallet_response.business_id).to eq nil
    expect(ewallet_response.status).to eq nil
  end
end
