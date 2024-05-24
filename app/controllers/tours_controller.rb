class ToursController < ApplicationController
  # before_action :search_upcoming, :filter_tours, only: :index

  def index
    @tours = Tour.all
    @tour_types = TourType.all
    search
    @pagy, @tours = pagy(@tours, items: Settings.tour.items_per_page)
  end

  private

  def search
    Tour::SEARCH_ATTRIBUTES.each do |field|
      @tours = @tours.public_send "by_#{field}", params[field]
    end
    if params[:or]
      @tours = @tours.by_city(params[:city])
                     .or(@tours.by_tour_type_id(params[:tour_type_id]))
    else
      Tour::OPTION_ATTRIBUTES.each do |field|
        @tours = @tours.public_send "by_#{field}", params[field]
      end
    end
  end
end
