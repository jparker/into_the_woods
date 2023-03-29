# frozen_string_literal: true

require 'test_helper'

class ReceivableTest < ActiveSupport::TestCase
  test 'validates presence of gross_rate' do
    receivable = Receivable.new gross_rate: nil
    receivable.validate

    assert_equal ['is not a number'], receivable.errors[:gross_rate]
  end

  test 'validates presence of commission_rate' do
    receivable = Receivable.new commission_rate: nil
    receivable.validate

    assert_equal ['is not a number'], receivable.errors[:commission_rate]
  end

  test 'validates commission_rate is greater than or equal to 0' do
    receivable = Receivable.new commission_rate: -0.01
    receivable.validate

    assert_equal ['must be in 0..1'], receivable.errors[:commission_rate]
  end

  test 'validates commission_rate is less than or equal to 1' do
    receivable = Receivable.new commission_rate: 1.01
    receivable.validate

    assert_equal ['must be in 0..1'], receivable.errors[:commission_rate]
  end

  test 'validates presence of commission' do
    receivable = Receivable.new commission: nil
    receivable.validate

    assert_equal ['is not a number'], receivable.errors[:commission]
  end
end
