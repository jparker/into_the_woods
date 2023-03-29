# frozen_string_literal: true

require 'test_helper'

class ReceiptTest < ActiveSupport::TestCase
  test 'validates presence of date' do
    receipt = Receipt.new date: nil
    receipt.validate

    assert_equal ["can't be blank"], receipt.errors[:date]
  end

  test 'validates presence of reference_no' do
    receipt = Receipt.new reference_no: nil
    receipt.validate

    assert_equal ["can't be blank"], receipt.errors[:reference_no]
  end
end
