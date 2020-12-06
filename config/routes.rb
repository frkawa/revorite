Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'posts#index'

  resources :posts, only: [:index, :new, :create, :destroy] do
    resources :likes, only: [:create, :destroy]
  end
end
