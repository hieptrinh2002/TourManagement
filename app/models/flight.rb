class Flight < ApplicationRecord
  has_many :tour_flights, dependent: :destroy
  has_many :tours, through: :tour_flights
  has_many :flight_tickets, dependent: :destroy

  # Scope để lấy các chuyến bay xuất phát vào một ngày cụ thể
  scope :departing_on, ->(date) { where("DATE(departure_time) = ?", date) }

  # Scope để lấy các chuyến bay đến một điểm đến thành phố
  scope :arriving_at, ->(city) { where(destination: city) }

  scope :order_by_brand, ->{order(airline_brand: :asc)}

end
