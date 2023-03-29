# frozen_string_literal: true

require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  test 'search by client/vendor' do
    pete, tony =
      create(:client, name: 'Peter Parker'),
      create(:client, name: 'Tony Stark')
    stark, shield =
      create(:vendor, name: 'Stark Industries'),
      create(:vendor, name: 'SHIELD')
    bookings =
      create(:booking, client: pete, vendor: stark),
      create(:booking, client: pete, vendor: shield),
      create(:booking, client: tony, vendor: shield)
    billables = bookings.map { |booking| create(:billable, booking:) }

    # Only clients match
    assert_equal billables[0..1], Billable.search('pete')
    # Only vendors match
    assert_equal billables[1..2], Billable.search('shield')
    # One client matches and one vendor matches
    assert_equal billables.values_at(0, 2), Billable.search('stark')
  end

  test 'search by client' do
    pete, tony =
      create(:client, name: 'Peter Parker'),
      create(:client, name: 'Tony Stark')
    stark, shield =
      create(:vendor, name: 'Stark Industries'),
      create(:vendor, name: 'SHIELD')
    bookings =
      create(:booking, client: pete, vendor: stark),
      create(:booking, client: pete, vendor: shield),
      create(:booking, client: tony, vendor: shield)
    billables = bookings.map { |booking| create(:billable, booking:) }

    assert_equal billables[2..2], Billable.search('client: stark')
  end

  test 'search by vendor' do
    pete, tony =
      create(:client, name: 'Peter Parker'),
      create(:client, name: 'Tony Stark')
    stark, shield =
      create(:vendor, name: 'Stark Industries'),
      create(:vendor, name: 'SHIELD')
    bookings =
      create(:booking, client: pete, vendor: stark),
      create(:booking, client: pete, vendor: shield),
      create(:booking, client: tony, vendor: shield)
    billables = bookings.map { |booking| create(:billable, booking:) }

    assert_equal billables[0..0], Billable.search('vendor: stark')
  end

  test 'search by booking date' do
    (Date.new(2023, 3, 25)..Date.new(2023, 3, 29)).each do |date|
      booking = create(:booking, date:)
      create(:billable, booking:)
    end

    assert_equal [Date.new(2023, 3, 27)], Billable.search('3/27/23').pluck(:date).sort
    assert_equal [
      Date.new(2023, 3, 26),
      Date.new(2023, 3, 27),
      Date.new(2023, 3, 28),
    ], Billable.search('3/26/23-3/28/23').pluck(:date).sort
    assert_equal [
      Date.new(2023, 3, 27),
      Date.new(2023, 3, 28),
      Date.new(2023, 3, 29),
    ], Billable.search('3/27/23-').pluck(:date).sort
    assert_equal [
      Date.new(2023, 3, 25),
      Date.new(2023, 3, 26),
      Date.new(2023, 3, 27),
    ], Billable.search('-3/27/23').pluck(:date).sort
  end

  test 'search by receipt date' do
    (Date.new(2023, 3, 25)..Date.new(2023, 3, 29)).each do |date|
      booking = create :booking, date: Date.new(2023, 1)
      billable = create(:billable, booking:)
      receipt = create(:receipt, date:)
      create(:receivable, billable:, receipt:)
    end
    booking = create :booking, date: Date.new(2023, 3, 27)
    create(:billable, booking:)

    assert_equal [
      Date.new(2023, 3, 27),
    ], Billable.search('receipt: 3/27/23').pluck('receipts.date').sort
    assert_equal [
      Date.new(2023, 3, 26),
      Date.new(2023, 3, 27),
      Date.new(2023, 3, 28),
    ], Billable.search('receipt: 3/26/23-3/28/23').pluck('receipts.date').sort
    assert_equal [
      Date.new(2023, 3, 27),
      Date.new(2023, 3, 28),
      Date.new(2023, 3, 29),
    ], Billable.search('receipt: 3/27/23-').pluck('receipts.date').sort
    assert_equal [
      Date.new(2023, 3, 25),
      Date.new(2023, 3, 26),
      Date.new(2023, 3, 27),
    ], Billable.search('receipt: -3/27/23').pluck('receipts.date').sort
  end
end
