module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [:login]

      def login
        token = Auth::LoginService.call(params[:email], params[:password])
        if token
          render json: { token: token, user: User.find_by(email: params[:email]).as_json(only: [:id, :email]) }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def logout
        token = request.headers["Authorization"]&.split(" ")&.last
        if token && Auth::LogoutService.call(token)
          render json: { message: "Logged out successfully" }, status: :ok
        else
          render json: { error: "Logout failed" }, status: :unprocessable_entity
        end
      end
    end
  end
end
