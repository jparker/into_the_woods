# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :client
  belongs_to :vendor

  validates :date, presence: true

  scope :sorted, -> { order :date }
end
