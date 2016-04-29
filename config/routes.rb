Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :meals do
    resources :orders
  end

  root 'meals#index'
  match '/orders/list/names', to: 'orders#list_names', via: 'post'
  match '/orders/list/dishes', to: 'orders#list_dishes', via: 'post'
end
