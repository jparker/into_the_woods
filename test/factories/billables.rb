# frozen_string_literal: true

FactoryBot.define do
  factory :billable do
    booking
    gross_rate { 1_000.to_d }
    collected { 0.to_d }
    commission_rate { 0.1.to_d }
    commission { commission_rate * gross_rate }
  end
end
