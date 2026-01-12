class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]

  def login
    token = Auth::LoginService.new(params[:email], params[:password]).call
    if token
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def logout
    token = request.headers["Authorization"]&.split(" ")&.last
    if token && Auth::LogoutService.new(token).call
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { error: "Logout failed" }, status: :unprocessable_entity
    end
  end
end
