# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codeschool/status/version'

Gem::Specification.new do |spec|
  spec.name          = "codeschool-status"
  spec.version       = Codeschool::Status::VERSION
  spec.authors       = ["Christopher Green"]
  spec.email         = ["chris@envylabs.com"]
  spec.description   = %q{An engine that provides common status polling endpoint for codeschool courses.}
  spec.summary       = %q{An engine that provides common status polling endpoint for codeschool courses.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'railties', '~> 3.0'
  spec.add_dependency 'active_model_serializers', '>= 0.8'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rails", "~> 3.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "combustion", "~> 0.5"
  spec.add_development_dependency "rspec-rails", "~> 2.0"
  spec.add_development_dependency "rake"
end
