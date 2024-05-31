class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights do |t|
      t.string :airline_brand
      t.string :flight_number
      t.datetime :departure_time
      t.datetime :arrival_time
      t.string :origin_place
      t.string :destination

      t.timestamps
    end
  end
end
