class CreateTourFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :tour_flights do |t|
      t.references :flight, null: false, foreign_key: true
      t.references :tour, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tour_flights, [:flight_id, :tour_id], unique: true
  end
end
