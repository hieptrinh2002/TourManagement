class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table :tours do |t|
      t.string :tour_name
      t.string :city
      t.string :tour_destination
      t.text :description
      t.decimal :price
      t.integer :day_duration
      t.date :start_date
      t.date :end_date
      t.integer :min_guests
      t.integer :max_guests
      t.decimal :deposit_percent
      t.integer :status, default: 0
      t.references :tour_type, null: false, foreign_key: true
      t.timestamps
    end
  end
end
