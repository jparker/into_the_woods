# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def search(query)
      return all if query.blank?

      where arel_table[:name].matches("%#{query.squish}%")
    end
  end
end
