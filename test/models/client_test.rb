# frozen_string_literal: true

require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test 'validates presence of name' do
    client = Client.new name: ' '
    client.validate

    assert_equal ["can't be blank"], client.errors[:name]
  end

  test 'search clients by name' do
    create :client, name: 'Peter Parker'
    create :client, name: 'Peter Quill'
    create :client, name: 'Natasha Romanoff'

    assert_equal ['Peter Parker', 'Peter Quill'],
                 Client.search('peter').pluck(:name).sort
  end
end
