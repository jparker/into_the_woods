# frozen_string_literal: true

class BillablesController < ApplicationController
  def index
    CachingSearch.transaction Billable.search(query).sorted do |relation|
      @relation = relation
      @pagy, @billables = pagy @relation.includes(booking: %i[client vendor])
      @billables.load
    end
  end

  private

  def query
    params[:q]
  end

  helper_method :query
end
