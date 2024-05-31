class Booking < ApplicationRecord
  BOOKING_ATTRIBUTES = %i(
    user_id
    tour_id
    flight_ticket_id
    phone_number
    number_of_guests
    started_date
  ).freeze

  scope :ordered_by_status, ->{order(status: :asc)}
  enum status: {pending: 0, confirmed: 1, cancelled: 2}
  enum payment_status: {payment_pending: 0, paid: 1, refunded: 2}
  belongs_to :tour
  belongs_to :user
  has_many :booking_vouchers, dependent: :destroy
  has_many :vouchers, through: :booking_vouchers
  belongs_to :flight_ticket, optional: true
  has_one :flight, through: :flight_ticket

  validates :number_of_guests,
            presence: true,
            numericality: {greater_than: Settings.booking.min_guests}

  validates :total_price,
            presence: true,
            numericality: {greater_than: Settings.booking.min_price}

  before_validation :calculate_total_price

  private
  def calculate_total_price
    self.total_price = tour.price
    return if flight_ticket.blank?

    self.total_price += flight_ticket.price * number_of_guests
    # add Coupons logic
  end
end
