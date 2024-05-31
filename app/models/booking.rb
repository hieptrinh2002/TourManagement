class Booking < ApplicationRecord
  scope :ordered_by_status, ->{order(status: :asc)}
  enum status: {pending: 0, confirmed: 1, cancelled: 2}
  enum payment_status: {payment_pending: 0, paid: 1, refunded: 2}
  belongs_to :tour
  belongs_to :user
  has_many :booking_vouchers, dependent: :destroy
  has_many :vouchers, through: :booking_vouchers
  belongs_to :flight_ticket, optional: true
  has_one :flight, through: :flight_ticket

  accepts_nested_attributes_for :flight_ticket

  validates :number_of_guests,
            presence: true,
            numericality: {greater_than: Settings.booking.min_guests}

  validates :total_price,
            presence: true,
            numericality: {greater_than: Settings.booking.min_price}

  before_validation  :calculate_total_price

  private
  def calculate_total_price
    self.total_price = tour.price

    if self.flight_ticket.present?
      self.total_price =self.total_price + self.flight_ticket.price * self.number_of_guests
    end

  end
end
