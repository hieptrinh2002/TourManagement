class Booking < ApplicationRecord
  BOOKING_ATTRIBUTES = %i(
    user_id
    tour_id
    flight_ticket_id
    phone_number
    number_of_guests
    started_date
    voucher_code
    total_price
  ).freeze

  scope :ordered_by_status, ->{order(status: :asc)}
  scope :ordered_by_created_at, ->{order(created_at: :desc)}

  enum status: {pending: 0, confirmed: 1, cancelled: 2}
  enum payment_status: {payment_pending: 0, paid: 1, refunded: 2}
  belongs_to :tour
  belongs_to :user
  has_many :booking_vouchers, dependent: :destroy
  has_many :vouchers, through: :booking_vouchers
  belongs_to :flight_ticket, optional: true
  has_one :flight, through: :flight_ticket

  scope :by_tour_name, (lambda do |name|
    if name.present?
      joins(:tour)
        .where("tours.tour_name LIKE ?", "%#{sanitize_sql_like(name)}%")
    end
  end)
  scope :by_min_guests, (lambda do |guests|
    where("number_of_guests >= ?", guests.presence ||
    Settings.booking.search.min_guests)
  end)
  scope :by_min_total_price, (lambda do |total_price|
    where("total_price >= ?", total_price.presence ||
    Settings.booking.search.min_total_price)
  end)
  scope :by_started_date, (lambda do |started_date|
    where("started_date >= ?", started_date.presence ||
    Settings.booking.search.min_started_date)
  end)
  scope :by_status, (lambda do |statuses|
    where(status: statuses) if statuses.present?
  end)

  scope :belongs_to_user, (lambda do |user_id|
    where(user_id:) if user_id.present?
  end)

  scope :for_tour, (lambda do |tour_id|
    where(tour_id:) if tour_id.present?
  end)

  accepts_nested_attributes_for :flight_ticket

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
