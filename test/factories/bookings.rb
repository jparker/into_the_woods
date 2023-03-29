# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    client
    vendor
    date { Date.current }
  end
end
