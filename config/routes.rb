Rails.application.routes.draw do
  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  devise_for :users, controllers: { confirmations: 'confirmations' }

  root to: 'pages#home'
  resources :trades do
    resources :steps, only: %i[show update], controller: 'steps_controllers/trades_steps'
    patch :confirm_presence, on: :member
    get :confirm_screen, on: :member
  end

  resources :profiles do
    member do
      get :invitations
    end
  end
end
