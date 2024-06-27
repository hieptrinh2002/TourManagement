class Tour < ApplicationRecord
  TOUR_ATTRIBUTES = %i(
    tour_name
    city
    tour_destination
    description
    price
    day_duration
    min_guests
    max_guests
    deposit_percent
    status
    tour_type_id
    images: []
  ).freeze

  SEARCH_ATTRIBUTES = %i(
    name
    start_date
    min_duration
    max_duration
    min_price
    max_price
    city
    tour_type_id
    status
  ).freeze

  enum status: {preparing: 0, active: 1, removed: 2}
  belongs_to :tour_type
  has_many :tour_flights, dependent: :destroy
  has_many :flights, through: :tour_flights
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :tour_name, presence: true,
                        length: {maximum: Settings.tour.max_len_name}
  validates :city, :tour_destination, :description, presence: true
  validates :day_duration, presence: true,
                           numericality: {only_integer: true,
                                          maximum: Settings.tour.max_duration,
                                          greater_than: Settings.digit_0}
  validates :price, presence: true,
                    numericality: {greater_than: Settings.digit_0}

  validates :min_guests, presence: true,
                         numericality: {only_integer: true,
                                        greater_than: Settings.digit_0}
  validates :max_guests, presence: true,
                         numericality: {only_integer: true,
                                        greater_than: Settings.digit_0}
  validates :deposit_percent, presence: true,
                              numericality: {greater_than: Settings.digit_0,
                                             less_than: Settings.digit_100}

  # Ensure max_guests is greater than or equal to min_guests
  validate :max_guests_greater_than_or_equal_to_min_guests

  has_many_attached :images do |attachable|
    attachable.variant :display, resize_to_limit: Settings.tour.limit_250_250
  end
  scope :upcoming, ->{order start_date: :asc}

  scope :order_by_status, ->{order status: :asc}

  scope :by_status, (lambda do |statuses|
    return if statuses.blank?

    ransack(status_in: statuses).result
  end)
  scope :by_destination, lambda {|tour_destination|
    if tour_destination.present?
      sanitized_destination = sanitize_sql_like(tour_destination)
      where("tour_destination LIKE ?", "%#{sanitized_destination}%")
    end
  }
  scope :by_start_date, lambda {|start_date|
    where("start_date >= ?", start_date.presence ||
    Settings.tour.search.start_date)
  }
  scope :by_tour_type_id, lambda {|tour_type_id|
    return if tour_type_id.to_i == 1 || tour_type_id.blank?

    where("tour_type_id = ?", tour_type_id)
  }

  def self.ransackable_attributes _auth_object = nil
    %w(tour_name day_duration city price status tour_destination address)
  end

  def self.ransackable_scopes _auth_object = nil
    %w(by_status by_started_date)
  end

  def self.ransackable_associations _auth_object = nil
    %w(bookings)
  end

  ransack_alias :address, :city_or_tour_destination

  private

  def max_guests_greater_than_or_equal_to_min_guests
    if max_guests.present? && min_guests.present? && max_guests < min_guests
      errors.add(:max_guests, I18n.t("errors.min_guest_greater_max_guest"))
    end
  end

  def start_date_after_today
    return if start_date.blank?

    return unless start_date <= Time.zone.today

    errors.add(:start_date, I18n.t("errors.start_date_today"))
  end
end
