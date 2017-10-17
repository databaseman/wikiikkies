Rails.application.routes.draw do
  devise_for :users
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user

  root "posts#index"

  resources :posts

  resources :users do
     resources :roles do
       resources :assignments
     end
  end

end
