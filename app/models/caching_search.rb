# frozen_string_literal: true

class CachingSearch
  TEMP_TABLE_NAME = 'search'

  def initialize(search)
    @search = search
  end

  attr_reader :search

  def prepare
    execute "CREATE TEMP TABLE #{TEMP_TABLE_NAME} AS #{query.to_sql}"
  end

  delegate :execute, to: :'search.connection'

  def relation
    search.unscoped.joins("INNER JOIN #{TEMP_TABLE_NAME} USING (id)").order temp_table[:sort_key]
  end

  private

  def query
    search.select :id, rank.as('sort_key')
  end

  def rank
    Arel::Nodes::NamedFunction.new('rank', []).over window
  end

  def window
    Arel::Nodes::Window.new.tap { |w| w.order(order_values) }
  end

  def order_values
    search.order_values.presence || search.arel_table[:id].asc
  end

  def temp_table
    Arel::Table.new TEMP_TABLE_NAME
  end
end
