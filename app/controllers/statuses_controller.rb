class StatusesController < ActionController::Base
  self.responder = Rapporteur::Responder
  respond_to :json

  def show
    respond_with(Rapporteur.run)
  end
end
