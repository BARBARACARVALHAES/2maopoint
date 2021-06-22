Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :trades do
    resources :trade_steps, only: %i[show update create]
  end
end
