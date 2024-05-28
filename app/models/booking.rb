class Booking < ApplicationRecord
  enum status: {pending: 0, confirmed: 1, cancelled: 2}
  enum payment_status: {payment_pending: 0, paid: 1, refunded: 2}
  belongs_to :tour
  belongs_to :user
  has_many :ticket_instances, dependent: :destroy
  has_many :booking_vouchers, dependent: :destroy
  has_many :vouchers, through: :booking_vouchers
  has_many :flight_tickets, through: :ticket_instances

  validates :phone_number,
            presence: true,
            format: {with: Regexp.new(Settings.VALID_PHONE_REGEX)}

  validates :number_of_guests,
            presence: true,
            numericality: {greater_than: Settings.booking.min_guests}

  validates :total_price,
            presence: true,
            numericality: {greater_than: Settings.booking.min_price}
end
