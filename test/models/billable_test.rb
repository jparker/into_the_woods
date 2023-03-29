# frozen_string_literal: true

require 'test_helper'

class BillableTest < ActiveSupport::TestCase
  test 'validates presence of gross_rate' do
    billable = Billable.new gross_rate: nil
    billable.validate

    assert_equal ['is not a number'], billable.errors[:gross_rate]
  end

  test 'validates presence of commission_rate' do
    billable = Billable.new commission_rate: nil
    billable.validate

    assert_equal ['is not a number'], billable.errors[:commission_rate]
  end

  test 'validates commission_rate is greater than or equal to 0' do
    billable = Billable.new commission_rate: -0.01
    billable.validate

    assert_equal ['must be in 0..1'], billable.errors[:commission_rate]
  end

  test 'validates commission_rate is less than or equal to 1' do
    billable = Billable.new commission_rate: 1.01
    billable.validate

    assert_equal ['must be in 0..1'], billable.errors[:commission_rate]
  end

  test 'validates presence of commission' do
    billable = Billable.new commission: nil
    billable.validate

    assert_equal ['is not a number'], billable.errors[:commission]
  end
end
