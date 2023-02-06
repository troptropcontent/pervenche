Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'robots#index'
  resources :services, only: %i[index new create]
  resources :robots, only: %i[index new create update]
  resources :automated_tickets, only: %i[new]
end
