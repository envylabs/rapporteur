require 'rubygems'
require 'bundler/setup'
require 'combustion'

ENV["RAILS_ENV"] ||= 'test'
Combustion.initialize! :action_controller, :active_record

require 'rspec/rails'
require 'rspec/collection_matchers'
require 'rapporteur/rspec3'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.before { Rapporteur.clear_checks }
end


# This is a shim to allow for Ruby 1.9.3, Rails 3.2 testing to pass.
# See https://github.com/rspec/rspec-rails/issues/1171.
Test::Unit.run = true if defined?(Test::Unit) && Test::Unit.respond_to?(:run=)
