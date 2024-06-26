class Flight < ApplicationRecord
  has_many :tour_flights, dependent: :destroy
  has_many :tours, through: :tour_flights
  has_many :flight_tickets, dependent: :destroy
  validates :airline_brand, presence: true

  # Scope to get flights departing on a specific date
  scope :departing_on, ->(date){where("DATE(departure_time) = ?", date)}

  # Scope to retrieve flights to a city destination
  scope :arriving_at, ->(city){where(destination: city)}

  # Scope to get flights departing on a specific date
  scope :departing_on, ->(date){where("DATE(departure_time) = ?", date)}

  # Scope to retrieve flights to a city destination
  scope :arriving_at, ->(city){where(destination: city)}

  scope :airline_brand, (lambda do |brand|
    where(airline_brand: brand) if airline_brand.present?
  end)

  scope :order_by_brand, ->{order(airline_brand: :asc)}
end
