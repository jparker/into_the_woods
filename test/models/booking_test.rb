# frozen_string_literal: true

require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  test 'validates presence of date' do
    booking = Booking.new date: nil
    booking.validate

    assert_equal ["can't be blank"], booking.errors[:date]
  end
end
