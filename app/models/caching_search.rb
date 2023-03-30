# frozen_string_literal: true

class CachingSearch
  TEMP_TABLE_NAME = 'search'

  def self.transaction(search)
    search.transaction do
      yield new(search).tap(&:prepare).then(&:relation)
    end
  end

  private_class_method :new

  def initialize(search)
    @search = search
  end

  attr_reader :search

  def prepare
    execute "CREATE TEMP TABLE #{TEMP_TABLE_NAME} ON COMMIT DROP AS #{query.to_sql}"
    execute "ANALYZE #{TEMP_TABLE_NAME}"
  end

  delegate :execute, to: :'search.connection'
  delegate :arel_table, to: :search

  def relation
    search.unscoped.joins("INNER JOIN #{TEMP_TABLE_NAME} USING (id)").order temp_table[:sort_key]
  end

  private

  def query
    # search.unscope(:order).distinct.select :id, rank.as('sort_key')
    search.unscope(:order).select(:id, rank.as('sort_key')).arel.then do |arel|
      arel.distinct_on arel_table[:id]
    end
  end

  def rank
    Arel::Nodes::NamedFunction.new('rank', []).over window
  end

  def window
    Arel::Nodes::Window.new.tap { |w| w.order(order_values) }
  end

  def order_values
    search.order_values.presence || arel_table[:id].asc
  end

  def temp_table
    Arel::Table.new TEMP_TABLE_NAME
  end
end
