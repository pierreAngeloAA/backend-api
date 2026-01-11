class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user, :current_device

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last
    decoded = Auth::JwtService.decode(token)

    device = Device.find_by(jwt_token: token)

    return render_unauthorized if decoded.nil? || device.nil? || device.revoked?

    @current_user = device.user
    @current_device = device
  end

  def render_unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
