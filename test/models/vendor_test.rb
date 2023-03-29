# frozen_string_literal: true

require 'test_helper'

class VendorTest < ActiveSupport::TestCase
  test 'validates presence of name' do
    vendor = Vendor.new name: ' '
    vendor.validate

    assert_equal ["can't be blank"], vendor.errors[:name]
  end

  test 'search vendors by name' do
    create :vendor, name: 'Stark Industries'
    create :vendor, name: 'Daily Bugle'
    create :vendor, name: 'Oscorp Industries'

    assert_equal ['Oscorp Industries', 'Stark Industries'],
                 Vendor.search('industries').pluck(:name).sort
  end
end
