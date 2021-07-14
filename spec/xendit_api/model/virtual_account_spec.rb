require 'spec_helper'

RSpec.describe XenditApi::Model::VirtualAccount do
  it 'returns expected attributes' do
    virtual_account_response = described_class.new(
      id: '123123123',
      owner_id: 'pquest001',
      external_id: 'billing-001',
      bank_code: 'BNI',
      merchant_code: '109283kdas',
      name: 'Nobu',
      account_number: 123_098_123,
      is_single_use: true,
      suggested_amount: 500_000,
      expected_amount: 500_000,
      status: 'PENDING',
      expiration_date: '2017-02-19',
      is_closed: true,
      currency: 'IDR'
    )
    expect(virtual_account_response).to have_attributes(
      id: '123123123',
      owner_id: 'pquest001',
      external_id: 'billing-001',
      bank_code: 'BNI',
      merchant_code: '109283kdas',
      name: 'Nobu',
      account_number: 123_098_123,
      is_single_use: true,
      suggested_amount: 500_000,
      expected_amount: 500_000,
      status: 'PENDING',
      expiration_date: '2017-02-19',
      is_closed: true,
      currency: 'IDR'
    )
  end
end
