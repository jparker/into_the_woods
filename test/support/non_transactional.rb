# frozen_string_literal: true

module NonTransactional
  extend ActiveSupport::Concern

  included do |cls|
    cls.use_transactional_tests = false

    setup :clean_database
    teardown :clean_database
  end

  def clean_database
    [Client, Vendor, Receipt].each do |cls|
      cls.connection.execute "TRUNCATE #{cls.table_name} CASCADE"
    end
  end
end
