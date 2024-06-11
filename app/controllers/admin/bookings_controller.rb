class Admin::BookingsController < Admin::AdminController
  include Admin::BookingsHelper

  before_action :set_booking, only: %i(show edit update)
  def index
    @pagy, @bookings = pagy(search_bookings,
                            items: Settings.tour.items_per_page)
  end

  def show; end

  def edit; end

  def update
    new_status = params[:status]
    if new_status.to_sym == :confirmed
      @booking.update status: new_status,
                      confirmed_date: current_time_formatted

    elsif new_status.to_sym == :cancelled
      @booking.update status: new_status,
                      cancellation_date: current_time_formatted
    end
    redirect_to admin_bookings_path
    flash[:success] = t "flash.booking.update_success"
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
    return if @booking

    redirect_to admin_tours_path, status: :see_other
    flash[:danger] = t "flash.booking.not_exist"
  end

  def status_params
    params.require(:booking).permit(:status)
  end

  def current_time_formatted
    Time.current.strftime(Settings.datime_format)
  end

  def search_bookings
    Booking.ordered_by_status
           .by_tour_name(params[:tour_name])
           .by_min_guests(params[:guests])
           .by_min_total_price(params[:total_price])
           .by_started_date(params[:started_date])
           .by_status(params[:status])
  end
end
