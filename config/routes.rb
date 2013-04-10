Rails.application.routes.draw do
  resource :_status, only: [:show], controller: 'statuses' 
end