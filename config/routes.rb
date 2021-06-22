Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :trades
  resources :profiles do
    member do
      get :invitations
    end
  end
end
