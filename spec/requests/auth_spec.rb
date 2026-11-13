require "rails_helper"

RSpec.describe "Auth", type: :request do
  let(:user) { create(:user) }

  describe "POST /api/v1/login" do
    it "returns a token and the user" do
      post "/api/v1/login", params: { email: user.email, password: "secret123" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["token"]).to be_present
      expect(response.parsed_body["user"]).to eq("id" => user.id, "email" => user.email)
    end

    it "rejects a wrong password" do
      post "/api/v1/login", params: { email: user.email, password: "nope" }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end

    it "issues tokens that expire" do
      token = login_as(user)

      expect(Auth::JwtService.decode(token)["exp"]).to be_within(60).of(24.hours.from_now.to_i)
    end

    it "keeps a single active session: logging in again revokes the previous token" do
      first = login_as(user)
      login_as(user)

      get "/api/v1/customers", headers: auth_headers(first)

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/logout" do
    it "revokes the token" do
      token = login_as(user)

      delete "/api/v1/logout", headers: auth_headers(token)
      expect(response).to have_http_status(:ok)

      get "/api/v1/customers", headers: auth_headers(token)
      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects requests without a token" do
      delete "/api/v1/logout"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "expired tokens" do
    it "are rejected" do
      token = login_as(user)

      travel 25.hours do
        get "/api/v1/customers", headers: auth_headers(token)
      end

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
