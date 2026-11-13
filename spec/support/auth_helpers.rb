module AuthHelpers
  def login_as(user, password: "secret123")
    post "/api/v1/login", params: { email: user.email, password: password }, as: :json
    response.parsed_body["token"]
  end

  def auth_headers(token)
    { "Authorization" => "Bearer #{token}" }
  end
end

RSpec.configure { |config| config.include AuthHelpers, type: :request }
