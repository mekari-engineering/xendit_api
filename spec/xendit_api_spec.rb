# frozen_string_literal: true

RSpec.describe XenditApi do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  describe '#configure' do
    after do
      # clening up cache test data
      described_class.configure do |config|
        config.logger = nil
      end
    end

    it 'returns expected custom logger' do
      custom_logger = Class.new(Object)
      described_class.configure do |config|
        config.logger = custom_logger
      end
      expect(described_class.configuration.logger).to eq custom_logger
    end
  end
end
