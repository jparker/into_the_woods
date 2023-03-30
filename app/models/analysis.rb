# frozen_string_literal: true

class Analysis
  def initialize(relation)
    @billables = relation
  end

  attr_reader :billables

  def gross_rate
    totals[:gross_rate]
  end

  def commission
    totals[:commission]
  end

  def totals
    self.load unless defined?(@totals)

    @totals
  end

  def load
    @totals = connection.select_one(billables.select(*sums)).transform_keys(&:to_sym)
  end

  def to_partial_path
    'billables/analysis'
  end

  private

  def sums
    [
      cumulative_gross_rate.as('gross_rate'),
      cumulative_commission.as('commission'),
    ]
  end

  def cumulative_gross_rate
    coalesce arel_table[:gross_rate].sum, 0
  end

  def cumulative_commission
    coalesce arel_table[:commission].sum, 0
  end

  delegate :arel_table, :connection, to: :billables
  delegate :coalesce, to: :arel_table
end
