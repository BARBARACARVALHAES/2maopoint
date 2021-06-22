Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :trades
  resources :profiles do
    get 'profiles/:id/invitations', to: 'profiles#invitations'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
