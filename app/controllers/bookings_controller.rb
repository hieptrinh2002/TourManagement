class BookingsController < ApplicationController
  include BookingsHelper
  before_action :authenticate_user!
  before_action :set_tour, only: %i(new create)
  before_action :get_booking, only: %i(show cancel edit update check_status)
  before_action :check_status, only: %i(edit update)

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

  def show
    return if current_user == User.find_by(id: @booking.user_id)

    flash[:danger] = t "flash.booking.unauthorized"
    redirect_to current_user, status: :see_other
  end

  def edit
    flights = Flight.departing_on(@booking.tour.start_date)
                    .arriving_at(@booking.tour.city)
                    .order_by_brand
    @pagy, @available_flights = pagy(flights, items: Settings.digit_4)
  end

  def update
    if @booking.update(booking_params)
      flash[:success] = t "flash.booking.update_success"
      redirect_to user_booking_path(@booking), status: :see_other
    else
      flash[:danger] = t "flash.booking.update_failed"
      redirect_to current_user, status: :unprocessable_entity
    end
  end

  def cancel
    voucher = Voucher.find_by(code: @booking.voucher_code)
    voucher.update(is_used: false)
    if @booking.update(status: :cancelled_by_user)
      flash[:success] = t "flash.booking.cancel_success"
      redirect_to root_path, status: :see_other
    else
      flash[:danger] = t "flash.booking.cancel_failure"
      redirect_to current_user, status: :unprocessable_entity
    end
  end

  private

  def check_status
    return if @booking.pending?

    flash[:danger] = t "flash.booking.access_denied"
    redirect_to user_booking_path(@booking), status: :see_other
  end

  def get_booking
    @booking = Booking.includes(:user, :tour, :flight_ticket)
                      .find_by(id: params[:id])
    @flight = Flight.find_by(id: @booking.flight_ticket&.flight_id)
    return if @booking.voucher_code.blank?

    @voucher = Voucher.find_by(code: @booking.voucher_code)
  end

  def handle_voucher
    return true if booking_params[:voucher_code].blank?

    voucher = Voucher.find_by(code: booking_params[:voucher_code])
    if voucher.blank?
      flash.now[:danger] = t "flash.booking.voucher_not_exist"
      return false
    end
    unless voucher.is_available? @tour.price
      flash[:danger] = t "flash.booking.voucher_unavailable"
      return false
    end

    voucher.update(is_used: true)
    true
  end

  def handle_booking
    if @booking.save
      flash[:success] = t "flash.booking.create_success"
      redirect_to user_booking_path(@booking.user, @booking)
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
