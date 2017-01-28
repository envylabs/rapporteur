module RouteHelper
  def self.included(base)
    base.routes { Rapporteur::Engine.routes }
  end
end
