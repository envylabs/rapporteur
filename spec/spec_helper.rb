require 'action_controller/railtie'

# Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |support|
#   require support
# end


require_relative "../lib/codeschool/status"

module Codeschool
  module Status
    class Application < ::Rails::Application
    end
  end
end

Codeschool::Status::Application.initialize!
require 'rspec/rails'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
