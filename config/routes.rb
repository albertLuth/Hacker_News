Rails.application.routes.draw do
  get 'thread/new'

  get 'thread/create'

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

  get '/threads', to: "posts#threads"


  # post '/comments', to: 'comments#create'

  Rails.application.routes.draw do  
    mount API::Base, at: "/"
  end
  

  resources :users
  resources :comments, except: :index do
    post :upvote, on: :member
    post :downvote, on: :member
  end

  resources :replies, except: :index do
    post :upvote, on: :member
    post :downvote, on: :member
  end
  resources :posts, except: :index do
    post :upvote, on: :member
    post :downvote, on: :member
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
