# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'application#index'
  resource :account
  resources :payments do
    post 'capture', to: 'payments#capture'
  end
  resources :webhooks, only: [:create]
  resources :plans, only: [:index]
  resources :subscriptions, only: [:create, :show] do
    post 'confirm', to: 'subscriptions#confirm'
  end
  get 'pricing', to: 'public#pricing'
  namespace :legal do
    get 'terms', to: 'legal#terms'
    get 'privacy', to: 'legal#privacy'
  end
  get '/auth/auth0/callback' => 'auth0#callback', as: :callback
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'

  namespace :admin do
    get '/' => 'admin#index'
  end
end
