Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :trades do
    resources :steps, only: %i[show update], controller: 'steps_controllers/trades_steps'
  end

  resources :profiles
end
