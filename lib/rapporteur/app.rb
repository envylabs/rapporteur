if defined?(I18n)
  locales_path = File.expand_path('../../../config/locales/*.yml', __FILE__)
  I18n.load_path << Dir[locales_path]
end

module Rapporteur
  class App
    CONTENT_TYPE = 'application/json'

    attr_accessor :checker

    def initialize(options={})
      self.checker = options.fetch(:checker) { Rapporteur }
    end

    def call(env)
      status = checker.run

      if status.errors.empty?
        [200, headers, [status.to_json]]
      else
        [500, headers, [{ errors: status.errors }.to_json]]
      end
    end

  private

    def headers
      { 'Content-Type' => CONTENT_TYPE }
    end
  end
end
