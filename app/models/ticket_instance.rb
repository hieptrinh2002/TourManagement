class TicketInstance < ApplicationRecord
  belongs_to :booking
  belongs_to :flight_ticket
end
