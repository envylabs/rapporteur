require 'active_support/deprecation'

module Rapporteur
  module CheckerDeprecations
    def add_check(*args, &block)
      ActiveSupport::Deprecation.warn("use Rapporteur.add_check", caller)
      Rapporteur.add_check(*args, &block)
    end

    def clear
      ActiveSupport::Deprecation.warn("use Rapporteur.clear_checks", caller)
      Rapporteur.clear_checks
    end

    def run
      ActiveSupport::Deprecation.warn("use Rapporteur.run", caller)
      Rapporteur.run
    end
  end
end
