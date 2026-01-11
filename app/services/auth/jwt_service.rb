class Auth::JwtService
  SECRET = Rails.application.secret_key_base

  def self.encode(payload)
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    JWT.decode(token, SECRET)[0]
  rescue JWT::DecodeError
    nil
  end
end
