ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require 'support/non_transactional'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  def assert_text(expected, within: nil)
    return assert_includes page_text_within_scope.squish, expected.squish unless within

    assert_select within do
      assert_text expected
    end
  end

  def page_text_within_scope
    @selected&.text || @html_document&.text || fragment(response.body).text
  end
end
