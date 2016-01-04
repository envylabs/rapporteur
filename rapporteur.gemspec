# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rapporteur/version'

Gem::Specification.new do |spec|
  spec.name          = "rapporteur"
  spec.version       = Rapporteur::VERSION
  spec.authors       = ["Envy Labs", "Code School"]
  spec.email         = [""]
  spec.description   = %q{An engine that provides common status polling endpoint.}
  spec.summary       = %q{An engine that provides common status polling endpoint.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'i18n', '~> 0.6'

  spec.add_development_dependency "appraisal", "~> 1.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "combustion", "~> 0.5", ">= 0.5.1"
  spec.add_development_dependency "rails", ">= 3.1", "< 5.1"
  spec.add_development_dependency "rspec-rails", "~> 3.2"
  spec.add_development_dependency "rspec-collection_matchers", "~> 1.0"
end
