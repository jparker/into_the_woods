# frozen_string_literal: true

class Billable < ApplicationRecord
  belongs_to :booking
  has_many :receivables, dependent: nil

  validates :gross_rate, numericality: true
  validates :commission_rate, numericality: { in: 0..1 }
  validates :commission, numericality: true

  scope :sorted, -> { joins(:booking).merge(Booking.sorted) }
  scope :search, ->(query) { Search.new(query, self).results }
end
