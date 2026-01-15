class Auth::LogoutService
  
  def self.call(token)
    device = Device.find_by(jwt_token: token)
    return false unless device

    device.update!(revoked_at: Time.current)
  end
end
