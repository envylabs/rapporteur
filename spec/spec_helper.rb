require 'rubygems'
require 'bundler/setup'
require 'combustion'

ENV["RAILS_ENV"] ||= 'test'
Combustion.initialize! :action_controller, :active_record

require 'rspec/rails'
require 'rspec/collection_matchers'
require 'rapporteur/rspec3'
require 'route_helper'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.before { Rapporteur.clear_checks }

  config.include RouteHelper, type: :controller
  config.include RouteHelper, type: :routing
end
