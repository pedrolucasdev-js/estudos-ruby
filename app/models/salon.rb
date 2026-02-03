class Salon < ApplicationRecord
  self.primary_key = "id"

  has_many :services, dependent: :destroy
  has_many :time_slots, dependent: :destroy
  has_many :appointments, dependent: :destroy

  validates :name, :phone, :slug, presence: true
  validates :slug, uniqueness: true
end
