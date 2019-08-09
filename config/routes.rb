# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'emails#new'

  resources :emails, only: %i[new create index]
end
