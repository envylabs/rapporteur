module Rapporteur
  class App
    CONTENT_TYPE = 'application/json'

    attr_accessor :checker

    def initialize(options={})
      self.checker = options.fetch(:checker) { Rapporteur }
    end

    def call(env)
      [200, { 'Content-Type' => CONTENT_TYPE }, [checker.run.to_json]]
    end
  end
end
