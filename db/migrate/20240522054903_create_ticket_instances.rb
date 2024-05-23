class CreateTicketInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_instances do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :flight, null: false, foreign_key: true
      t.integer :number

      t.timestamps
    end
    add_index :ticket_instances, [:booking_id, :flight_id], unique: true
  end
end
