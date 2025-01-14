require 'spec_helper'

RSpec.describe XenditApi::Errors::CreditCard do
  describe 'ResponseError' do
    it 'is expected parent class' do
      expect(described_class::ResponseError.superclass).to eq(XenditApi::Errors::ResponseError)
    end
  end

  describe 'ChargeError' do
    it 'is expected parent class' do
      expect(described_class::ChargeError.superclass).to eq(XenditApi::Errors::CreditCard::ResponseError)
    end
  end

  describe 'CardDeclined' do
    it 'is expected parent class' do
      expect(described_class::CardDeclined.superclass).to eq(XenditApi::Errors::CreditCard::ResponseError)
    end

    it 'is returns expected message' do
      expect do
        raise described_class::CardDeclined
      end.to raise_error described_class::CardDeclined, 'The card you are trying to capture has been declined by the issuing bank.'
    end
  end

  describe 'ExpiredCard' do
    it 'is expected parent class' do
      expect(described_class::ExpiredCard.superclass).to eq(XenditApi::Errors::CreditCard::ResponseError)
    end
  end

  describe 'InsufficientBalance' do
    it 'is expected parent class' do
      expect(described_class::InsufficientBalance.superclass).to eq(XenditApi::Errors::CreditCard::ResponseError)
    end
  end

  describe 'StolenCard' do
    it 'is expected parent class' do
      expect(described_class::StolenCard.superclass).to eq(XenditApi::Errors::CreditCard::ResponseError)
    end
  end

  describe 'InactiveCard' do
    it 'is expected parent class' do
      expect(described_class::InactiveCard.superclass).to eq(XenditApi::Errors::CreditCard::ResponseError)
    end
  end

  describe 'InvalidCvn' do
    it 'is expected parent class' do
      expect(described_class::InvalidCvn.superclass).to eq(XenditApi::Errors::CreditCard::ResponseError)
    end
  end

  describe 'CreditCardChargeNotFoundError' do
    it 'is expected parent class' do
      expect(described_class::CreditCardChargeNotFoundError.superclass).to eq(XenditApi::Errors::CreditCard::ResponseError)
    end
  end
end
