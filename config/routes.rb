Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'automated_tickets#index'
  resources :services, only: %i[index new create]
  resources :robots, only: %i[index new create update]

  resources :automated_tickets, only: %i[new index show destroy update] do
    resources :setup, only: %i[show update edit], controller: 'automated_tickets/setup', param: :step_name
  end

  resource :onboarding, only: :show do
    get 'welcome', to: 'onboardings#welcome'
  end
end
