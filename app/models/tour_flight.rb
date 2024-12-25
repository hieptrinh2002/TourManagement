class TourFlight < ApplicationRecord
  belongs_to :flight
  belongs_to :tour
end
