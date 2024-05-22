class Flight < ApplicationRecord
  has_many :tour_flights, dependent: :destroy
  has_many :tours, through: :tour_flights
  has_many :flight_tickets, dependent: :destroy
end
