class Auth::LoginService
  def initialize(email, password)
    @user = User.find_by(email:)
    @password = password
  end

  def call
    return nil unless @user&.authenticate(@password)

    token = Auth::JwtService.encode(user_id: @user.id)
    @user.devices.create!(jwt_token: token)
    token
  end
end
