class Auth::LogoutService
  def initialize(device)
    @device = device
  end

  def call
    @device.update!(revoked_at: Time.current)
  end
end
