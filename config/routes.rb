Rails.application.routes.draw do

  devise_for :users

  root "posts#index"

  resources :posts

  resources :users do
     resources :roles do
       resources :assignments
     end
   end
end
