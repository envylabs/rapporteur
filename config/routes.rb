Rails.application.routes.draw do
  resource :status, :only => [:show]# , :as => :_status
end