require 'active_model_serializers'

require "codeschool/status/engine" if defined?(Rails)
require "codeschool/status/version"

module Codeschool
  module Status
    autoload :Checker, 'codeschool/status/checker'
    autoload :Checks, 'codeschool/status/checks'
    autoload :Responder, 'codeschool/status/responder'
    autoload :Revision, 'codeschool/status/revision'
    autoload :Serializer, 'codeschool/status/serializer'
  end
end
