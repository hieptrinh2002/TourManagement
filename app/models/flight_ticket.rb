class FlightTicket < ApplicationRecord
  enum ticket_class: {economy_class: 0, business_class: 1, first_class: 2}
  has_many :ticket_instances, dependent: :destroy
  belongs_to :flight
end
