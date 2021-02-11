Rails.application.routes.draw do
  get 'users/show'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  root 'posts#index'

  resources :users, only: [:index, :show] do
    member do
      get :likes, :followings, :followers
    end
    resources :relationships, only: [:create, :destroy]
  end
  resources :posts, only: [:index, :new, :create, :destroy] do
    collection do
      get :trend
    end
    resources :comments, only: [:create, :destroy]
    resources :reposts, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end
end
