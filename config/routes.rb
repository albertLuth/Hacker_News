Rails.application.routes.draw do
  root 'posts#index'

  get '/newest', to: "posts#newest"
  get '/ask', to: "posts#ask"

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  # post '/comments', to: 'comments#create'

  resources :posts
  resources :users
  resources :comments
  resources :replies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end