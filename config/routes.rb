Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

namespace :api do
  resources :salons
  resources :services

  resources :appointments do
    collection do
      get :availability
    end

    member do
      patch :confirm
      patch :finish
      patch :cancel
    end
  end
end
end
