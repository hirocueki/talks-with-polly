Rails.application.routes.draw do
  resources :talks, only: %i(index create new show destroy)
  root "talks#index"
end
