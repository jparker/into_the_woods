# frozen_string_literal: true

class Vendor < ApplicationRecord
  include Searchable

  validates :name, presence: true
end
