require 'rubygems'
require 'bundler/setup'
require 'combustion'

ENV["RAILS_ENV"] ||= 'test'

require 'rapporteur/engine' # the engine must be loaded before the app boots
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
