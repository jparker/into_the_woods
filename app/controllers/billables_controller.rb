# frozen_string_literal: true

class BillablesController < ApplicationController
  def index
    @cache = CachingSearch.new Billable.search(query).sorted
    @cache.prepare
    @pagy, @billables = pagy @cache.relation.includes(booking: %i[client vendor])
  end

  private

  def query
    params[:q]
  end

  helper_method :query
end
