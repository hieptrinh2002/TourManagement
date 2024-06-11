class BookingsController < ApplicationController
  include BookingsHelper
  before_action :authenticate_user!
  before_action :set_tour

  def new
    @booking = current_user.bookings.build tour_id: @tour.id

    flights_scope = Flight.departing_on(@tour.start_date)
                          .arriving_at(@tour.city)
                          .order_by_brand

    if params[:airline_brand].present?
      flights_scope = flights_scope.airline_brand(params[:airline_brand])
    end

    @pagy, @available_flights = pagy(flights_scope, items: Settings.digit_4)
    @available_vouchers = get_available_voucher @tour.price
  end

  def create
    @booking = Booking.new(booking_params)
    return unless handle_voucher

    handle_booking
  end

  private

  def handle_voucher
    voucher = Voucher.find_by(code: booking_params[:voucher_code])
    if voucher.blank?
      flash.now[:danger] = t "flash.booking.voucher_not_exist"
      return false
    elsif !voucher.is_available? @tour.price
      flash[:danger] = t "flash.booking.voucher_unavailable"
      return false
    end

    voucher.update(is_used: true)
    true
  end

  def handle_booking
    if @booking.save
      flash[:success] = t "flash.booking.create_success"
      redirect_to tours_path
    else
      flash[:danger] = t "flash.booking.create_failed"
      render :new
    end
  end

  def get_available_voucher total_price
    Voucher.by_min_total_price(total_price)
           .available
           .valid
           .max_discount
  end

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
