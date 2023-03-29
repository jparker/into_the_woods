# frozen_string_literal: true

FactoryBot.define do
  factory :receivable do
    billable
    receipt
    gross_rate { billable.gross_rate }
    commission_rate { billable.commission_rate }
    commission { commission_rate * gross_rate }
  end
end
