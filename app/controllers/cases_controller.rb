# Controller to retrieve San Francisco 311 case info.
class CasesController < ApplicationController
  include ParamParsers

  before_action :load_pagination, only: :index
  before_action -> { parse_params :near, :since, :status }, only: :index

  def index
    @cases = Sf311Case.includes(:category, :source)
             .filter_by(filter_params)
             .page(@page).per_page(@per_page)

    @total_count = @cases.total_entries
    @total_pages = @cases.total_pages
  end

  private

  def filter_params
    params.permit(:category)
      .merge!(near_array: @near, near_distance: near_distance,
              since_time: @since, status: @status)
  end

  def near_distance
    params[:near_distance] || 5
  end
end
