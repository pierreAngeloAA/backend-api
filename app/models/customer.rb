class Customer < ApplicationRecord
  validates :document, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :email, presence: true
end
