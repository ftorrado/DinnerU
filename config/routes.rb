Rails.application.routes.draw do
  root 'meals#index'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :users
  resources :meals do
    resources :orders
  end
  resources :dishes

  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
