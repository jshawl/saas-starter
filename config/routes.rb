# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'application#index'
  resource :account
  resources :payments do
    post 'capture', to: 'payments#capture'
  end

  resources :plans, only: [:index]
  resources :subscriptions, only: [:create, :show] do
    post 'confirm', to: 'subscriptions#confirm'
  end

  namespace :legal do 
    get 'terms', to: 'legal#terms'
    get 'privacy', to: 'legal#privacy'
  end
end
