# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', passwords: 'users/passwords' }

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

  resource :admin, only: [], controller: 'admin' do
    get 'dashboard'
    resources :diagnostics, only: [] do
      collection do
        resources :client, only: :show, param: :client_kind, constraints: { client_kind: /pay_by_phone/ },
                           controller: 'admin/diagnostics/client'
      end
    end
  end

  namespace :webhooks do
    namespace :charge_bee do
      post '/:token', action: 'handle'
    end
  end

  authenticate :user, ->(user) { user.has_role?('admin') } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
