require 'spec_helper'
require 'xendit_api/url_masker'

RSpec.describe XenditApi::UrlMasker do
  describe '.mask' do
    it 'returns expected with valid URL' do
      url = 'https://example.com?token=1234567890123456&cvv=123&other_param=value&account_number=123456789&bank=bca'
      expected = 'https://example.com?token=*****&cvv=*****&other_param=value&account_number=123******&bank=*****'
      options = {
        full_hide_params: %w[token cvv],
        mask_params: %w[account_number bank]
      }
      expect(described_class.mask(url, options)).to eq(expected)
    end

    it 'returns expected with empty URL' do
      url = ''
      expected = ''
      options = {
        full_hide_params: %w[token cvv],
        mask_params: %w[account_number name]
      }
      expect(described_class.mask(url, options)).to eq(expected)
    end

    it 'returns expected when there is no query string' do
      url = 'https://example.com'
      expected = 'https://example.com'
      options = {
        full_hide_params: %w[token cvv],
        mask_params: %w[account_number name]
      }
      expect(described_class.mask(url, options)).to eq(expected)
    end
  end
end
