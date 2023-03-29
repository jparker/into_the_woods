# frozen_string_literal: true

class Client < ApplicationRecord
  include Searchable

  validates :name, presence: true
end
