class Auth::LogoutService
  def initialize(token)
    @token = token
  end

  def call
    device = Device.find_by(jwt_token: @token)
    return false unless device

    device.update!(revoked_at: Time.current)
  end
end
