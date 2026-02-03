Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :salons
    resources :services
    resources :appointments
  end
end
