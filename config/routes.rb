Rapporteur::Engine.routes.draw do
  get("status.:format", {
    :as => :status,
    :constraints => {:format => "json"},
    :defaults => {:format => "json"},
    :to => "statuses#show"
  })
end

Rails.application.routes.draw do
  unless Rails.application.routes.named_routes[:status]
    mount Rapporteur::Engine => "/"
    get("/status.:format", {
      :as => :status,
      :constraints => {:format => "json"},
      :defaults => {:format => "json"},
      :to => "statuses#show"
    })
  end
end
