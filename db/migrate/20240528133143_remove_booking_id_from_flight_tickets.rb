class RemoveBookingIdFromFlightTickets < ActiveRecord::Migration[7.0]
  def change
    remove_column :flight_tickets, :booking_id, :bigint
  end
end
