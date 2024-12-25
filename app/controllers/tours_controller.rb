class ToursController < ApplicationController
  before_action :tour, only: :show
  load_and_authorize_resource

  def show
    @relevant_pagy,
    @relevant_tours = pagy(Tour.by_tour_type_id(@tour.tour_type_id),
                           items: Settings.tour.rev_tours_per_page)

    @reviews = @tour.reviews.order_by_create_at
    return if params[:star].blank?

    @reviews = @reviews.by_rating(params[:star])
  end

  def index
    @q = Tour.ransack(params[:q])
    @tours = @q.result.by_status(params[:statuses])
    @pagy, @tours = pagy(@tours, items: Settings.tour.items_per_page)
  end

  private

  def tour
    @tour = Tour.find_by(id: params[:id])
    return if @tour.present?

    flash[:danger] = t "flash.tour.find_tour_failed"
    redirect_to tours_path
  end

  def search
    Tour::SEARCH_ATTRIBUTES.each do |field|
      @tours = @tours.public_send "by_#{field}", params[field]
    end
  end
end
