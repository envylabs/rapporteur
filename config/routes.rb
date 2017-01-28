Rapporteur::Engine.routes.draw do
  get '/(.:format)', to: 'statuses#show', as: :status
end

unless Rails.application.routes.routes.any? { |r| Rapporteur::Engine == r.app.app }
  ActiveSupport::Deprecation.warn('Rapporteur was not explicitly mounted in your application. Please add an explicit mount call to your /config/routes.rb. Automatically mounted Rapporteur::Engine to /status for backward compatibility. This will be no longer automatically mount in Rapporteur 4.')
  Rails.application.routes.draw do
    mount Rapporteur::Engine, at: '/status'
  end
end
