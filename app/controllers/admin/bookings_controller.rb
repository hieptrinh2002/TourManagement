class Admin::BookingsController < Admin::AdminController
  include Admin::BookingsHelper
  before_action :set_breadcrumbs
  before_action :set_booking, only: %i(show edit update)
  load_and_authorize_resource

  def index
    @q = Booking.ransack(params[:q])
    @bookings = @q.result.by_status(params[:statuses]).order_by_status
    @pagy, @bookings = pagy(@bookings, items: Settings.digit_10)
  end

  def show
    add_breadcrumb(@booking.tour.tour_name)
  end

  def edit; end

  def update
    if @booking.pending?
      if @booking.update(booking_update_params)
        flash[:success] = t "flash.booking.update_success"
        redirect_to admin_bookings_path, status: :see_other
      else
        flash.now[:danger] = t "flash.booking.update_failed"
        render :show, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = t "flash.booking.invalid_update"
      render :show, status: :unprocessable_entity
    end
  end

  private

  def booking_update_params
    params.require(:booking).permit Booking::UPDATE_ATTRIBUTES
  end

  def set_breadcrumbs
    add_breadcrumb(t("breadcrumb.home"), admin_path)
    add_breadcrumb(t("breadcrumb.bookings"), admin_bookings_path)
  end

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
    Time.current.strftime(Settings.datetime_format)
  end
end
