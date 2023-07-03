# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  namespace :emails do
    resources :templates, only: %i[index show] do
      post :deliver
    end
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Defines the root path route ("/")
  root 'automated_tickets#index'
  resources :services, only: %i[new create edit update]
  resources :automated_tickets, only: %i[new index destroy update] do
    collection do
      get 'export'
    end
    resources :setup, only: %i[show update edit], controller: 'automated_tickets/setup', param: :step_name do
      member do
        put 'reset'
      end
    end
  end

  namespace :billing do
    resources :customers, only: %i[show], param: :customer_id do
      member do
        resource :address, only: %i[update edit]
      end
    end
    resources :subscriptions, only: %i[index destroy], param: :subscription_id
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
        resource :tickets_to_renew, only: :show, controller: 'admin/diagnostics/tickets_to_renew'
      end
    end
  end

  namespace :webhooks do
    namespace :billable do
      post '/:token', action: 'handle'
    end
    namespace :billing do
      post '/:token', action: 'handle'
    end
  end

  authenticate :user, ->(user) { user.has_role?('admin') } do
    mount Sidekiq::Web => '/sidekiq'
    mount Blazer::Engine => '/blazer'
  end
end
