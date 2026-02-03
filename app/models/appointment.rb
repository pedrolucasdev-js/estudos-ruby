class Appointment < ApplicationRecord
  self.primary_key = "id"

  belongs_to :salon
  belongs_to :service

  STATUSES = %w[pending confirmed]

  validates :date, :hour, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
end
