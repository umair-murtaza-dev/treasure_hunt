Rails.application.routes.draw do
  resources :treasure_hunt, only: :create
  resources :analytics, only: :index
end
