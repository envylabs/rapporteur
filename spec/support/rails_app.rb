module TestRailsApp
  def rails_app
    require 'active_support/core_ext/numeric'
    require 'action_controller/railtie'
    require 'sprockets/railtie'

    return CODESCHOOL_STATUS_RAILS_RAILTIE_TEST_APP if defined?(CODESCHOOL_STATUS_RAILS_RAILTIE_TEST_APP)

    app = Class.new(Rails::Application) do
      config.active_support.deprecation = :stderr
      config.secret_token = SecureRandom.uuid
      config.logger = Logger.new('/dev/null')

      config.assets.enabled = false
      config.assets.cache_store = [:memory_store, size: 1.megabyte]
    end
    Object.const_set 'CODESCHOOL_STATUS_RAILS_RAILTIE_TEST_APP', app

    CODESCHOOL_STATUS_RAILS_RAILTIE_TEST_APP.initialize!
    CODESCHOOL_STATUS_RAILS_RAILTIE_TEST_APP.routes.clear!
    Rails.application = CODESCHOOL_STATUS_RAILS_RAILTIE_TEST_APP
    CODESCHOOL_STATUS_RAILS_RAILTIE_TEST_APP
  end
end

RSpec.configure do |config|
  config.include TestRailsApp
end