Rails.application.routes.draw do
  root "posts#index" # defines a route for "/" to point at the index action of the PostsController
  resources :posts
end
