Rapporteur::Engine.routes.draw do
  get '/(.:format)', to: 'statuses#show', as: :status
end
