class StatusesController < ActionController::Base
  self.responder = Codeschool::Status::Responder
  respond_to :json

  def show
    respond_with(Codeschool::Status::Checker.check, {
      serializer: Codeschool::Status::Serializer
    })
  end
end
