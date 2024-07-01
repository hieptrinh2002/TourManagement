class Admin::AdminController < ApplicationController
  layout "admin"
  load_and_authorize_resource

  def index
    @monthly_revenue = Booking.monthly_revenue
    @cancellation_rate = Booking.cancellation_rate
    @customer_created_by_month = User.customer_created_by_month
    @average_rating_per_tour = Review.average_rating_per_tour
    @bookings_per_month = Booking.bookings_per_month
  end
end
