class FlightTicket < ApplicationRecord
  enum ticket_class: {economy: 0, business: 1, first: 2}
  has_many :ticket_instances, dependent: :destroy
  belongs_to :flight
end
