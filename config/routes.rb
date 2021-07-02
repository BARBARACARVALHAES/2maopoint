Rails.application.routes.draw do
  get 'errors/not_found'
  get 'errors/internal_server_error'
  get 'errors/not_authorized'
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
    patch :realized_trade, on: :member
  end

  get "/404", to: "errors#not_found", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
  get "/422", to: "errors#unprocessable", via: :all

  resources :profiles do
    member do
      get :invitations
    end
  end
end
