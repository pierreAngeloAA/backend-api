class Device < ApplicationRecord
  belongs_to :user

  def revoked?
    revoked_at.present?
  end
end
