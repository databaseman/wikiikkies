Rails.application.routes.draw do
  devise_for :users
  root "posts#index" # defines a route for "/" to point at the index action of the PostsController
  resources :posts
end
