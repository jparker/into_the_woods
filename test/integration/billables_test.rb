# frozen_string_literal: true

require "test_helper"

class BillablesTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = false

  teardown do
    [Client, Vendor, Receipt].each do |cls|
      cls.connection.execute "TRUNCATE #{cls.table_name} CASCADE"
    end
  end

  test 'list billables' do
    client = create :client, name: 'Peter Parker'
    vendor = create :vendor, name: 'Daily Bugle'
    booking = create :booking, client:, vendor:, date: Date.new(2023, 3, 28)
    billable = create :billable, booking:, gross_rate: 1_000.0, commission_rate: 0.1
    receipt = create :receipt
    create(:receivable, billable:, receipt:)

    get billables_path

    assert_response :success
    assert_select 'tbody > .billable' do
      assert_text 'Peter Parker'
      assert_text 'Daily Bugle'
      assert_text '$1,000.00', within: '.gross_rate'
      assert_text '$100.00', within: '.commission'
    end
    assert_select 'tfoot' do
      assert_text '$1,000.00', within: '.gross_rate'
      assert_text '$100.00', within: '.commission'
    end
  end

  test 'list billables shows totals across all pages of results' do
    billables = create_list :billable, 3, gross_rate: 1_000.0, commission_rate: 0.1

    get billables_path(items: 2, page: 1)

    assert_response :success
    assert_select '.billable', count: 2
    assert_select 'a.page-link[rel="next"]', text: '2'
    assert_select 'tfoot' do
      assert_text '$3,000.00', within: '.gross_rate'
      assert_text '$300.00', within: '.commission'
    end

    get billables_path(items: 2, page: 2)
    assert_select '.billable', count: 1
    assert_select 'a.page-link[rel="prev"]', text: '1'
    assert_select 'tfoot' do
      assert_text '$3,000.00', within: '.gross_rate'
      assert_text '$300.00', within: '.commission'
    end
  end

  test 'search billables' do
    pete, tony =
      create(:client, name: 'Peter Parker'),
      create(:client, name: 'Tony Stark')
    bugle, stark =
      create(:vendor, name: 'Daily Bugle'),
      create(:vendor, name: 'Stark Industries')
    [
      { client: pete, vendor: bugle, date: Date.new(2023, 3, 25) },
      { client: pete, vendor: stark, date: Date.new(2023, 3, 26) },
      { client: tony, vendor: stark, date: Date.new(2023, 3, 26) },
      { client: pete, vendor: stark, date: Date.new(2023, 3, 27) },
    ].each do |params|
      booking = create :booking, **params
      create :billable, booking:, gross_rate: 1_000.0, commission_rate: 0.1
    end

    get billables_path(q: 'pete stark 3/26/23')

    assert_response :success
    assert_select '.billable', count: 1
    assert_select 'tfoot' do
      assert_text '$1,000.00'
      assert_text '$100.00'
    end
  end

  test 'search billables deduplicates results' do
    billable = create :billable, gross_rate: 1_000.0, commission_rate: 0.1
    receipts = create_pair :receipt, date: Date.new(2023, 3, 29)
    receipts.each do |receipt|
      create :receivable, billable:, receipt:, gross_rate: 500.0
    end

    get billables_path(q: 'receipt: 3/29/23')

    assert_response :success
    assert_select '.billable', count: 1
    assert_select 'tfoot' do
      assert_text '$1,000.00'
      assert_text '$100.00'
    end
  end
end
