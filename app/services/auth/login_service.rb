class Auth::LoginService
  # Locals only: this used to keep the user in a class-level @user, which is
  # shared by every Puma thread, so two concurrent logins could mix users up.
  def self.call(email, password)
    user = User.find_by(email: email)
    return nil unless user&.authenticate(password)

    token = Auth::JwtService.encode(user_id: user.id, jti: SecureRandom.uuid)

    # One active session per user: a new login revokes the previous tokens.
    user.devices.where(revoked_at: nil).update_all(revoked_at: Time.current)
    user.devices.create!(jwt_token: token, revoked_at: nil)

    token
  end
end
