Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'automated_tickets#index'
  resources :services, only: %i[index new create]
  resources :robots, only: %i[index new create update]
  resources :automated_tickets, only: %i[new index show destroy update] do
    resources :setups, only: %i[show update], controller: 'automated_tickets/setups' do
      member do
        get 'content', to: 'automated_tickets/setups#content'
      end
    end
  end
  resource :onboarding, only: :show do
    get 'welcome', to: 'onboardings#welcome'
  end
  resource :setup, controller: :setup do
    get 'service'
    get 'localisation'
    get 'vehicle'
    get 'zipcode'
    get 'rate_options'
    get 'weekdays'
    get 'payment_methods'
  end
end
