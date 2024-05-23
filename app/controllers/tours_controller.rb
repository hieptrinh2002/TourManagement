class ToursController < ApplicationController
  def index
    @pagy, @tours = pagy(Tour.upcoming,
                         items: Settings.tour.items_per_page)
  end
end
