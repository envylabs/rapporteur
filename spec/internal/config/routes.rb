# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rapporteur::Engine, at: '/status'
end
