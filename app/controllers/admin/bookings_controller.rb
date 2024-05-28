class Admin::BookingsController < Admin::AdminController
  include Admin::BookingsHelper

  before_action :set_booking, only: %i(show edit update destroy)
  def index
    @pagy, @bookings = pagy(Booking.all,
                         items: Settings.tour.items_per_page)
  end

  def show; end

  def edit; end

  def update
    new_status = params[:status]
    if new_status.to_sym == :confirmed
      @booking.update_columns status: new_status,
                              confirmed_date: Time.now.strftime(Settings.datime_format)

    elsif new_status.to_sym == :cancelled
      @booking.update_columns status: new_status,
                              cancellation_date: Time.now.strftime(Settings.datime_format)
    end
    redirect_to admin_bookings_path
    flash[:success] = t "flash.booking.update_success"
  end

  def destroy
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
end
