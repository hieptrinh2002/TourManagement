class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tour, only: %i(new create)
  before_action :get_booking, only: %i(show cancel edit update check_status)
  before_action :check_status, only: %i(edit update)
  before_action :get_current_user_used_voucher_ids, only: %i(new create)

  def new
    redirect_to tours_path unless booking_active?

    @booking = current_user.bookings.build(tour_id: @tour.id)
    @available_flights, @pagy = pagy(fetch_available_flights,
                                     items: Settings.digit_4)
    @available_vouchers = get_available_vouchers(@tour.price)
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
    delete_user_voucher voucher if voucher.present?
    if @booking.update(status: :cancelled_by_user)
      flash[:success] = t "flash.booking.cancel_success"
      redirect_to root_path, status: :see_other
    else
      flash[:danger] = t "flash.booking.cancel_failure"
      redirect_to current_user, status: :unprocessable_entity
    end
  end

  private

  def booking_active?
    unless @tour.active?
      flash[:danger] = t "flash.tour.cannot_book"
      return false
    end

    true
  end

  def fetch_available_flights
    flights_scope = Flight.departing_on(@tour.start_date)
                          .arriving_at(@tour.city)
                          .order_by_brand

    if params[:airline_brand].present?
      flights_scope = flights_scope.airline_brand params[:airline_brand]
    end

    flights_scope
  end

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

  def validate_guests_number
    if @booking.number_of_guests < @tour.min_guests ||
       @booking.number_of_guests > @tour.max_guests
      flash[:danger] = t "flash.booking.invalid_guests"
      return false
    end

    true
  end

  def validate_booking_date
    return true if @booking.started_date >= Time.zone.now

    flash[:danger] = t "flash.booking.invalid_start_date"
    false
  end

  def validate_voucher code
    voucher = Voucher.find_by(code:)
    return true if voucher.blank?

    unless voucher.is_available? @tour.price
      flash[:danger] = t("flash.booking.voucher_unavailable")
      return false
    end

    true
  end

  def update_voucher_usage voucher
    voucher.update(used: voucher.used + 1)
  end

  def handle_voucher
    return true if booking_params[:voucher_code].blank?

    code = booking_params[:voucher_code]
    return false unless validate_voucher code

    voucher = Voucher.find_by(code:)

    return false if @current_user_used_voucher_ids.include? voucher.id

    Booking.transaction do
      update_voucher_usage voucher
      create_user_voucher voucher
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    flash[:danger] = e.message
    false
  end

  def delete_user_voucher voucher
    return if voucher.code.blank?

    voucher.update(used: voucher.used - 1) if voucher.present?
    user_voucher = UserVoucher.find_by(user: current_user, voucher:)
    return if user_voucher.destroy

    flash[:danger] = t "flash.voucher.delete_failed"
  end

  def create_user_voucher voucher
    UserVoucher.create!(user: current_user, voucher:)
  end

  def handle_booking
    return false unless validate_guests_number && validate_booking_date

    if @booking.save
      flash[:success] = t "flash.booking.create_success"
      redirect_to user_booking_path(@booking.user, @booking)
    else
      flash[:danger] = t "flash.booking.create_failed"
      render :new
    end
  end

  def get_available_vouchers total_price
    Voucher.by_min_total_price(total_price)
           .available
           .can_use
           .not_used(@current_user_used_voucher_ids)
  end

  def get_current_user_used_voucher_ids
    @current_user_used_voucher_ids = UserVoucher.used_by(current_user.id)
                                                .pluck(:voucher_id)
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
