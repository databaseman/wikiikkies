Rails.application.routes.draw do
  authenticated :user do
   root 'posts#index', as: :authenticated_root
  end
  root "welcome#index"

  get  'about'       => 'welcome#about'
  get  'contact'     => 'welcome#contact'
  get  'help'        => 'welcome#help'

  namespace :admin do
    root 'application#index'
    resources :roles
  end

  devise_for :users
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user #need this for delete user

  resources :users
  resources :assignments
  resources :posts

  resources :users do
    resources :posts
  end

  resources :posts do
    resources :collaborators
  end

end
