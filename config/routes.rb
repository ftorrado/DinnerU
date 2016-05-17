Rails.application.routes.draw do
  root 'meals#index'

  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :users
  resources :meals do
    post 'invite' => 'meals#invite'
    post 'uninvite/:user_id' => 'meals#uninvite'
    resources :comments, only: [:create, :destroy]
    resources :orders do
      resources :comments, only: [:create, :destroy]
      resources :dishes, only: [:create, :destroy]
    end
  end
  resources :dishes

  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
