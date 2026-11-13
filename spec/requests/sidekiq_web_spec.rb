require "rails_helper"

RSpec.describe "Sidekiq dashboard", type: :request do
  it "is not reachable without credentials" do
    get "/sidekiq"

    expect(response).to have_http_status(:unauthorized)
  end

  it "opens with the configured credentials" do
    stub_const("ENV", ENV.to_h.merge("SIDEKIQ_WEB_USERNAME" => "admin", "SIDEKIQ_WEB_PASSWORD" => "s3cret"))

    get "/sidekiq", headers: { "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "s3cret") }

    expect(response).not_to have_http_status(:unauthorized)
  end

  it "stays closed when no password is configured, even with a guess" do
    stub_const("ENV", ENV.to_h.except("SIDEKIQ_WEB_PASSWORD"))

    get "/sidekiq", headers: { "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials("", "") }

    expect(response).to have_http_status(:unauthorized)
  end
end
