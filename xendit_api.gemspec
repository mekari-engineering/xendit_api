# frozen_string_literal: true

require_relative 'lib/xendit_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'xendit_api'
  spec.version       = XenditApi::VERSION
  spec.authors       = ['Philip Lambok']
  spec.email         = ['philiplambok71@gmail.com']

  spec.summary       = 'Ruby API wrapper for Xendit payment gateway'
  spec.description   = 'Ruby API wrapper for Xendit payment gateway'
  spec.homepage      = 'https://github.com/mekari-engineering/xendit_api'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['allowed_push_host'] = 'https://github.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mekari-engineering/xendit_api'
  spec.metadata['changelog_uri'] = 'https://github.com/mekari-engineering/xendit_api'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'faraday', '~> 1.0'
  spec.add_dependency 'faraday_middleware', '~> 1.0'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
