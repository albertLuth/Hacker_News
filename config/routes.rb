Rails.application.routes.draw do
  get 'posts/index'

  get 'posts/new'
  get 'posts/show'
  get 'posts/edit'
  root 'posts#index'

  get '/newest', to: "posts#newest"
  get '/ask', to: "posts#ask"

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'


  # post '/comments', to: 'comments#create'

  resources :users
  resources :comments, except: :index do
    post :upvote, on: :member
    post :downvote, on: :member
  end

  resources :replies
  resources :posts, except: :index do
    post :upvote, on: :member
    post :downvote, on: :member
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
