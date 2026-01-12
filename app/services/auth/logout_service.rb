class Auth::LogoutService
  def initialize(token)
    @token = token
  end

  def call
    RevokedToken.create!(token: @token)
  end
end
