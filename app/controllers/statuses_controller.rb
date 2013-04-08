class StatusesController < ActionController::Base
  respond_to :json
  
  def show
    respond_with({ 
      activerecord_ok: activerecord_ok?,
      templating_ok: templating_ok?,
      revision: current_revision })
  end
  
  private
  
  ##
  # Tests ActiveRecord by performing a simple query.
  #
  def activerecord_ok?
    @activerecord_ok ||=
      true if ActiveRecord::Base.connection.execute('select current_date as CurrentDate').first["CurrentDate"]
  end
  
  ##
  # Tries to find current application revision.
  #
  def current_revision
    Codeschool::Status::Revision.new.current
  end
  
  ##
  # Renders a template to reach to the top of the stack.
  #
  def templating_ok?
    render_to_string(partial: 'status', formats: [:html], object: activerecord_ok?)
  end
end
