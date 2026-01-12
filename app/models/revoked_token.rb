class RevokedToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true
end
