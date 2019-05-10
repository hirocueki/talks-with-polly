Rails.application.routes.draw do
  root "texts#index"

  resources :talks, only: %i(index create new show destroy)
  resources :texts
end
