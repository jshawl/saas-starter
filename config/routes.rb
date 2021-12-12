Rails.application.routes.draw do
  devise_for :users
  root to: 'application#index'
  resource :account
  namespace :legal do
    get 'terms', to: 'legal#terms'
    get 'privacy', to: 'legal#privacy'
  end
end
