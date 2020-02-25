Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, except: [:index]
  resources :sessions, only: [:create]
  resources :genres, only: [:index]
  resources :artists, only: [:index]
  resources :games, except: [:delete]
end
