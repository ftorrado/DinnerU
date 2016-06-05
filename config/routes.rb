Rails.application.routes.draw do
  root 'meals#index'

  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get 'zomato/locations' => 'zomato#locations'
  get 'zomato/restaurants' => 'zomato#restaurants'

  resources :users
  resources :meals do
    post 'invites' => 'meals#invite', as: :invite
    delete 'invites/:user_id' => 'meals#uninvite', as: :uninvite
    resources :comments, only: [:create, :destroy]
    resources :orders do
      resources :comments, only: [:create, :destroy]
      post 'dishes' => 'orders#add_dish', as: :add_dish
      delete 'dishes/:dish_id' => 'orders#remove_dish', as: :rm_dish
    end
  end
  resources :dishes

  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
