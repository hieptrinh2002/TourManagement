class ChangeFlightIdToFlightTicketIdInTicketInstances < ActiveRecord::Migration[7.0]
  def change
    rename_column :ticket_instances, :flight_id, :flight_ticket_id
  end
end
