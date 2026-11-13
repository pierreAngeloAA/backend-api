require "sidekiq/web"

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Mount Sidekiq Web UI for monitoring background jobs
  # Basic auth on every environment: the dashboard can delete and retry jobs.
  # Credentials are read per request, so changing them needs no restart.
  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      post "/login", to: "auth#login"
      delete "/logout", to: "auth#logout"

      resources :customers, only: [ :index, :show, :create, :update, :destroy ]

      resources :imports, only: [ :create, :show ] do
        member do
          get :errors
        end
      end
    end
  end
end
