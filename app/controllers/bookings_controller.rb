class BookingsController < ApplicationController
  include BookingsHelper
  before_action :authenticate_user!
  before_action :set_tour

  def new
    @available_flights = Flight.departing_on(@tour.start_date).arriving_at(@tour.city)
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

  def edit; end

  def update ; end

  def destroy; end

  private

  def set_tour
    @tour = Tour.find_by(id: params[:tour_id])
    return if @tour.present?

    flash[:danger] = t "flash.tour.find_tour_failed"
    redirect_to tours_path
  end

  def booking_params
    params.require(:booking).permit(:user_id, :tour_id, :flight_ticket_id, :phone_number, :number_of_guests, :started_date)
  end
end
