require "sidekiq/web"

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Mount Sidekiq Web UI for monitoring background jobs
  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      post "/login", to: "auth#login"
      delete "/logout", to: "auth#logout"

      resources :customers, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
