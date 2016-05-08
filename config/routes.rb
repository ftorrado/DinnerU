Rails.application.routes.draw do
  root 'meals#index'
  get 'signup' => 'users#new'
  match '/orders/list/dishes', to: 'orders#list_dishes', via: 'post'

  resources :meals do
    resources :orders
  end
  resources :users

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
