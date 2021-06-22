Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :trades
  resources :trade_steps
end
