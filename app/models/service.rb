class Service < ApplicationRecord
  self.primary_key = "id"

  belongs_to :salon
  has_many :appointments

  validates :name, :duration_minutes, :price, presence: true
end
