require "sidekiq/web"

Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  # Mount Sidekiq Web UI for monitoring background jobs
  mount Sidekiq::Web => "/sidekiq"
end
