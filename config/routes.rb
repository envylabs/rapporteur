# frozen_string_literal: true

Rapporteur::Engine.routes.draw do
  get '/(.:format)', to: 'statuses#show', as: :status
end

explicitly_mounted = Rails.application.routes.routes.any? { |r|
  (Rapporteur::Engine == r.app) || (r.app.respond_to?(:app) && Rapporteur::Engine == r.app.app)
}

unless explicitly_mounted
  ActiveSupport::Deprecation.warn('Rapporteur was not explicitly mounted in your application. Please add an explicit mount call to your /config/routes.rb. Automatically mounted Rapporteur::Engine to /status for backward compatibility. This will be no longer automatically mount in Rapporteur 4.') # rubocop:disable Layout/LineLength
  Rails.application.routes.draw do
    mount Rapporteur::Engine, at: '/status'
  end
end
