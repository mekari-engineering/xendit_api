require 'spec_helper'

RSpec.describe XenditApi::Errors::ResponseError do
  it 'could raise expected error without any argument' do
    expect do
      raise described_class
    end.to raise_error described_class
  end

  it 'could raise expected error with one argument' do
    expect do
      raise described_class, 'The charge error'
    end.to raise_error described_class, 'The charge error'
  end

  it 'could raise expected error with two argument' do
    expect do
      raise described_class.new('The charge error', { payload: 'hello' })
    end.to raise_error do |error|
      expect(error).to be_kind_of described_class
      expect(error.message).to eq 'The charge error'
      expect(error.payload).to eq({ payload: 'hello' })
    end
  end
end
