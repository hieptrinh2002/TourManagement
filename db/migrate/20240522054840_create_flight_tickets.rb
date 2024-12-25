class CreateFlightTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :flight_tickets do |t|
      t.references :flight, null: false, foreign_key: true
      t.integer :ticket_class
      t.decimal :price

      t.timestamps
    end
  end
end
