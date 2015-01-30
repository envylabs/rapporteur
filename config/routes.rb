Rails.application.routes.draw do
  get 'status.:format', :to => 'statuses#show', :defaults => {:format => 'json'}, :constraints => {:format => 'json'}, :as => :status
end
