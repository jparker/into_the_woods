# frozen_string_literal: true

FactoryBot.define do
  factory :vendor do
    sequence(:name) { |n| "Vendor #{n}" }
  end
end
