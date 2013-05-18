require 'active_model_serializers'

require "codeschool/status/engine" if defined?(Rails)
require "codeschool/status/version"

module Codeschool
  module Status
    autoload :Checker, 'codeschool/status/checker'
    autoload :Responder, 'codeschool/status/responder'
    autoload :Revision, 'codeschool/status/revision'
  end
end
