Rails.application.routes.draw do
  root 'meals#index'
  get 'signup' => 'users#new'

  resources :meals do
    resources :orders
  end
  resources :users
  resources :dishes

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
