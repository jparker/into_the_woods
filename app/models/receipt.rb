# frozen_string_literal: true

class Receipt < ApplicationRecord
  has_many :receivables, dependent: nil

  validates :date, presence: true
  validates :reference_no, presence: true
end
