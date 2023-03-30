# frozen_string_literal: true

class BillablesController < ApplicationController
  def index
    CachingSearch.transaction Billable.search(query).sorted do |relation|
      @pagy, @billables = pagy relation.includes(booking: %i[client vendor])
      @analysis = Analysis.new relation
      @analysis.load
      @billables.load
    end
  end

  private

  def query
    params[:q]
  end

  helper_method :query
end
