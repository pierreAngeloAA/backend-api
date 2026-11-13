class Auth::JwtService
  SECRET = Rails.application.secret_key_base
  ALGORITHM = "HS256".freeze
  TTL = 24.hours

  # Every token carries an expiry: a leaked token stops working on its own
  # instead of living until someone logs out.
  def self.encode(payload)
    JWT.encode(payload.merge(exp: TTL.from_now.to_i), SECRET, ALGORITHM)
  end

  # The algorithm is pinned so a token signed with "none" (or any other
  # algorithm) is rejected. ExpiredSignature is a DecodeError, so expired
  # tokens also return nil.
  def self.decode(token)
    JWT.decode(token, SECRET, true, algorithm: ALGORITHM)[0]
  rescue JWT::DecodeError
    nil
  end
end
