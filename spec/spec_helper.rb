# frozen_string_literal: true

require 'xendit_api'
require 'pry'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr/'
  config.hook_into :webmock
  # Replace <AUTH_KEY> with your actual secret key when doing testing
  config.filter_sensitive_data('<AUTH_KEY>', 'FILTERED_AUTH_KEY')
  config.before_record do |interaction|
    interaction.request.headers['Authorization'] = 'FILTERED_AUTH_KEY'
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
