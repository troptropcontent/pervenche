# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'automated_tickets#index'
  resources :services, only: %i[new create]
  resources :automated_tickets, only: %i[new index destroy update] do
    resources :setup, only: %i[show update edit], controller: 'automated_tickets/setup', param: :step_name
  end

  resource :onboarding, only: :show do
    get 'welcome', to: 'onboardings#welcome'
  end
  resources :shared_views, only: [] do
    collection do
      get 'loading'
    end
  end

  resource 'admin', only: [], controller: 'admin' do
    get 'dashboard'
  end
end
