Rails.application.routes.draw do
  get 'collaborators/show'
  get 'users/index'
  get 'users/show'

  get  'about'       => 'welcome#about'
  get  'contact'     => 'welcome#contact'
  get  'help'        => 'welcome#help'

  resources :charges, only: [:new, :create]
  get  'upgrade'   => 'charges#upgrade'
  get  'downgrade'   => 'charges#downgrade'
  post 'downgrade'   => 'charges#downgrade_user'

  authenticated :user do
   root 'posts#index', as: :authenticated_root
  end
  root "welcome#index"

  namespace :admin do
    root 'application#index'
    resources :roles
  end

  devise_for :users
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user #need this for delete user

  resources :assignments

  resources :posts do
    resources :collaborators
  end

end
