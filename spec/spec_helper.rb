# frozen_string_literal: true

require 'bundler/setup'
require 'combustion'

ENV['RAILS_ENV'] ||= 'test'
Combustion.initialize! :action_controller, :active_record

require 'rspec/rails'
require 'rspec/collection_matchers'
require 'rapporteur/rspec3'
require 'route_helper'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = '.rspec_status'
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end

  config.before do Rapporteur.clear_checks end

  config.include RouteHelper, type: :controller
  config.include RouteHelper, type: :routing
end
