Rails.application.routes.draw do
  get 'users/show'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'posts#index'

  resources :users, only: [:show] do
    member do
      get :likes
    end
  end
  resources :posts, only: [:index, :new, :create, :destroy] do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
end
