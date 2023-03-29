# frozen_string_literal: true

class Receivable < ApplicationRecord
  belongs_to :billable
  belongs_to :receipt

  validates :gross_rate, numericality: true
  validates :commission_rate, numericality: { in: 0..1 }
  validates :commission, numericality: true
end
