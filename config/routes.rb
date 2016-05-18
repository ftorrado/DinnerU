Rails.application.routes.draw do
  root 'meals#index'

  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :users
  resources :meals do
    post 'invites/:user_id' => 'meals#invite'
    delete 'invites/:user_id' => 'meals#uninvite'
    resources :comments, only: [:create, :destroy]
    resources :orders do
      resources :comments, only: [:create, :destroy]
      post 'dishes/:dish_id' => 'orders#add_dish'
      delete 'dishes/:dish_id' => 'orders#remove_dish'
    end
  end
  resources :dishes

  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
