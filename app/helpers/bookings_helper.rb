module BookingsHelper
  def time_difference_in_hours_and_minutes datetime1, datetime2
    # Calculate the time difference in seconds
    time_difference_in_seconds = (datetime1 - datetime2).abs

    # Convert to minutes
    total_minutes = (time_difference_in_seconds / 60).to_i

    # Calculate hours and minutes
    hours = total_minutes / 60
    minutes = total_minutes % 60

    # format
    "#{hours}h #{minutes}p"
  end

  def get_all_airline_brand
    Flight.distinct.pluck(:airline_brand)
  end

  def booking_exists_for_user_and_tour? user, tour
    return false if user.blank? || tour.blank?

    bookings = Booking.for_tour(tour.id)
                      .belongs_to_user(user.id)
                      .confirmed
                      .started_before_now

    bookings.any?
  end
end
