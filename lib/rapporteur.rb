require 'active_model_serializers'

require "rapporteur/engine" if defined?(Rails)
require "rapporteur/version"

module Rapporteur
  autoload :Checker, 'rapporteur/checker'
  autoload :Checks, 'rapporteur/checks'
  autoload :Responder, 'rapporteur/responder'
  autoload :Revision, 'rapporteur/revision'
  autoload :Serializer, 'rapporteur/serializer'
end
