Rails.application.routes.draw do
  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  devise_for :users
  root to: 'pages#home'
  resources :trades do
    resources :steps, only: %i[show update], controller: 'steps_controllers/trades_steps'
  end
  resources :profiles do
    member do
      get :invitations
    end
  end
end
