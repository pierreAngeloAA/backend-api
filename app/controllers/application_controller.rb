class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    decoded = Auth::JwtService.decode(token)

    device = Device.find_by(jwt_token: token)

    if decoded.nil? || device.nil? || device.revoked?
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end

    @current_user = device.user
    @current_device = device
  rescue JWT::DecodeError, JWT::ExpiredSignature
    render json: { error: "Invalid or expired token" }, status: :unauthorized
  end
end
