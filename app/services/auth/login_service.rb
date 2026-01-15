class Auth::LoginService

  def self.call(email, password)
    @user = User.find_by(email: email)
    return nil unless @user&.authenticate(password)

    payload = {
      user_id: @user.id,
      jti: SecureRandom.uuid
    }

    token = Auth::JwtService.encode(payload)

    @user.devices.where(revoked_at: nil).update_all(revoked_at: Time.current)

    @user.devices.create!(jwt_token: token, revoked_at: nil)

    token
  end
end
