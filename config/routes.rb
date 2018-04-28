Rails.application.routes.draw do
  get 'links/index'

  get 'links/new'

  get 'links/show'

  get 'links/edit'

  root 'posts#index'

  get '/newest', to: "posts#newest"
  get '/ask', to: "posts#ask"

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :posts
  resources :users
  resources :links, except: :index do
  resources :comments, only: [:create, :edit, :update, :destroy]
  post :upvote, on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
