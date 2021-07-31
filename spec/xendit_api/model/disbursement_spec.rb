require 'spec_helper'

RSpec.describe XenditApi::Model::Disbursement do
  it 'returns expected disbursement' do
    disbursement = described_class.new(external_id: 'hello', amount: 500_000)
    expect(disbursement.external_id).to eq 'hello'
    expect(disbursement.amount).to eq 500_000
  end

  it 'returns expected disbursement when there is new undefined attribute' do
    disbursement = described_class.new(external_id: 'hello', hello: 'world')
    expect(disbursement.external_id).to eq 'hello'
  end
end
