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
    deposit
  ).freeze

  UPDATE_ATTRIBUTES = %i(
    status
    canceled_reason
    cancellation_date
    confirmed_date
  ).freeze

  scope :ordered_by_status, ->{order(status: :asc)}
  scope :ordered_by_created_at, ->{order(created_at: :desc)}
  enum status: {pending: 0, confirmed: 1, cancelled: 2, cancelled_by_user: 3}
  enum payment_status: {payment_pending: 0, paid: 1, refunded: 2}
  belongs_to :tour
  belongs_to :user
  belongs_to :flight_ticket, optional: true
  has_one :flight, through: :flight_ticket

  scope :by_tour_name, (lambda do |name|
    if name.present?
      joins(:tour)
        .where("tours.tour_name LIKE ?", "%#{sanitize_sql_like(name)}%")
    end
  end)

  scope :pending_or_past_confirmed, (lambda do
    where("status = ? OR (status = ? AND started_date < ?)",
          "pending", "confirmed", Time.zone.today ||
          Settings.booking.search.min_started_date)
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

  scope :confirmed, (lambda do
    where(status: "confirmed")
  end)
  scope :started_before_now, (lambda do
    where("started_date < ?", Time.zone.now)
  end)

  accepts_nested_attributes_for :flight_ticket

  validates :started_date, :status, presence: true
  validates :number_of_guests,
            presence: true,
            numericality: {greater_than: Settings.booking.min_guests}

  validates :total_price,
            presence: true,
            numericality: {greater_than: Settings.booking.min_price}

  before_validation :calculate_total_price

  private

  def calculate_total_price
    calculate_tour_price
    calculate_flight_ticket_price
    calculate_deposit
    apply_voucher_discount
  end

  def calculate_tour_price
    self.total_price = tour.price
  end

  def calculate_flight_ticket_price
    return if flight_ticket.blank?

    self.total_price += flight_ticket.price * number_of_guests
  end

  def apply_voucher_discount
    return if voucher_code.blank?

    voucher = Voucher.find_by(code: voucher_code)
    return if voucher.blank?

    discount = 1 - voucher.percent_discount.to_f / 100
    self.total_price *= discount
    self.deposit = [deposit, self.total_price].min
  end

  def calculate_deposit
    self.deposit = self.total_price.to_f * (tour.deposit_percent.to_f / 100)
  end
end
