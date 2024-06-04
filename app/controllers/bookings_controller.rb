class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tour

  def new
    @booking = current_user.bookings.build tour_id: @tour.id
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      flash[:success] = t "flash.booking.create_success"
      redirect_to tours_path
    else
      flash[:danger] = t "flash.booking.create_failed"
      render :new
    end
  end

  private

  def set_tour
    @tour = Tour.find_by(id: params[:tour_id])
    return if @tour.present?

    flash[:danger] = t "flash.tour.find_tour_failed"
    redirect_to tours_path
  end

  def booking_params
    params.require(:booking).permit Booking::BOOKING_ATTRIBUTES
  end
end
