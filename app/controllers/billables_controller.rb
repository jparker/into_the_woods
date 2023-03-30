# frozen_string_literal: true

class BillablesController < ApplicationController
  def index
    @search = Billable.where id: Billable.search(query)
    @analysis = Analysis.new @search
    @pagy, @billables = pagy @search.includes(booking: %i[client vendor]).sorted
  end

  private

  def query
    params[:q]
  end

  helper_method :query
end
