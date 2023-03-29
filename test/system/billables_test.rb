# frozen_string_literal: true

require 'application_system_test_case'

class BillablesTest < ApplicationSystemTestCase
  test 'list billables' do
    pete, tony =
      create(:client, name: 'Peter Parker'),
      create(:client, name: 'Tony Stark')
    bugle, stark =
      create(:vendor, name: 'Daily Bugle'),
      create(:vendor, name: 'Stark Industries')
    [
      { client: pete, vendor: bugle, date: Date.new(2023, 3, 25) },
      { client: pete, vendor: stark, date: Date.new(2023, 3, 26) },
      { client: tony, vendor: stark, date: Date.new(2023, 3, 27) },
    ].each do |params|
      booking = create :booking, **params
      create :billable, booking:, gross_rate: 1_000.0, commission_rate: 0.1
    end

    visit root_path

    assert_selector '.billable', count: 3
    within 'tfoot' do
      assert_text '$3,000.00'
      assert_text '$300.00'
    end

    fill_in 'Query', with: 'pete'
    click_on 'Search'

    assert_selector '.billable', count: 2
    within 'tfoot' do
      assert_text '$2,000.00'
      assert_text '$200.00'
    end
  end
end
