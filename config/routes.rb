Rails.application.routes.draw do
  get 'status.json', :to => 'statuses#show', :defaults => {:format => 'json'}, :as => :status
end
