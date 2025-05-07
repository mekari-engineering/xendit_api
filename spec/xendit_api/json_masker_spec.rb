require 'spec_helper'
require 'xendit_api/json_masker'

RSpec.describe XenditApi::JsonMasker do
  describe '.mask' do
    it 'returns nil when input is nil' do
      expect(described_class.mask(nil, mask_params: %w[card_number expiration_date cvv name email], full_hide_params: %w[amount account_number])).to be_nil
    end

    it 'returns empty string when input is empty string' do
      expect(described_class.mask('', mask_params: %w[card_number expiration_date cvv name email], full_hide_params: %w[amount account_number])).to eq('')
    end

    it 'returns array when input is array' do
      expect(described_class.mask([], mask_params: %w[card_number expiration_date cvv name email], full_hide_params: %w[amount account_number])).to eq([])
    end

    it 'returns expected when data is an array' do
      parsed = [
        {
          card_number: '123456789012',
          cvv: '123',
          address: 'Jakarta',
          email: 'hello@email.com'
        },
        {
          card_number: '123456789012',
          cvv: '123',
          address: 'Jakarta',
          email: 'hello@email.com'
        }
      ]

      masked = [
        {
          'card_number' => '*****',
          'cvv' => '*****',
          'address' => 'Jakarta',
          'email' => 'hel************'
        },
        {
          'card_number' => '*****',
          'cvv' => '*****',
          'address' => 'Jakarta',
          'email' => 'hel************'
        }
      ]

      output = described_class.mask(parsed.to_json, mask_params: %w[email], full_hide_params: %w[card_number cvv])

      expect(output).to eq(masked)
    end

    it 'returns expected with valid JSON' do
      parsed = {
        card_number: '1234567890123456',
        expiration_date: '12/23',
        cvv: '***',
        name: 'John Doe',
        address: 'Jakarta',
        external_id: '12398123123',
        information: {
          email: 'bill@john.com',
          account_number: '1092830182309123'
        },
        items: [
          {
            quantity: 89_821_823,
            amount: 15_000,
            email: 'john@bill.com',
            more_info: {
              email: 'hello@gmail.com',
              booking_id: '1234567890',
              page: 1,
              limit: 2
            }
          }
        ]
      }

      masked = {
        'card_number' => '123*************',
        'expiration_date' => '*****',
        'cvv' => '*****',
        'name' => 'Joh*****',
        'address' => 'Jakarta',
        'external_id' => '12398123123',
        'information' => {
          'email' => 'bil**********',
          'account_number' => '*****'
        },
        'items' => [
          {
            'quantity' => 89_821_823,
            'amount' => '*****',
            'email' => 'joh**********',
            'more_info' => {
              'email' => 'hel************',
              'booking_id' => '1234567890',
              'page' => 1,
              'limit' => 2
            }
          }
        ]
      }

      output = described_class.mask(parsed.to_json, mask_params: %w[card_number expiration_date cvv name email], full_hide_params: %w[amount account_number])

      expect(output).to eq(masked)
    end

    it 'returns expected with invalid JSON' do
      data = 'this is invalid json'
      output = described_class.mask(data, mask_params: %w[card_number expiration_date cvv name email], full_hide_params: %w[amount account_number])

      expect(output).to eq(data)
    end
  end
end
