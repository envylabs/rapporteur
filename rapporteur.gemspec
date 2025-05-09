# frozen_string_literal: true

require_relative 'lib/rapporteur/version'

Gem::Specification.new do |spec|
  spec.name          = 'rapporteur'
  spec.version       = Rapporteur::VERSION
  spec.authors       = ['Envy Labs']
  spec.email         = ['']
  spec.description   = 'An engine that provides common status polling endpoint.'
  spec.summary       = 'An engine that provides common status polling endpoint.'
  spec.homepage      = 'https://github.com/envylabs/rapporteur'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.2'

  spec.metadata['source_code_uri'] = 'https://github.com/envylabs/rapporteur'
  spec.metadata['changelog_uri'] = 'https://github.com/envylabs/rapporteur/blob/main/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'i18n', '>= 0.6', '< 2'

  spec.add_development_dependency 'appraisal', '~> 2.1'
  spec.add_development_dependency 'combustion', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rspec-rails', '~> 7.0'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_development_dependency 'rubocop-rails_config', '~> 1.0'
end
