class TimeSlot < ApplicationRecord
  self.primary_key = "id"

  belongs_to :salon

  scope :available, -> { where(available: true) }

  validates :date, :hour, presence: true
end
