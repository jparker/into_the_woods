# frozen_string_literal: true

FactoryBot.define do
  factory :receipt do
    date { Date.current }
    sequence(:reference_no, 1_000) { |n| n.to_s }
  end
end
