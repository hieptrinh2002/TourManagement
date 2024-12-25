class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :tour, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :flight_ticket, foreign_key: true
      t.string :phone_number
      t.integer :number_of_guests
      t.datetime :started_date
      t.decimal :total_price
      t.integer :payment_status, default: 0
      t.datetime :confirmed_date
      t.string :voucher_code
      t.datetime :cancellation_date
      t.integer :status, default: 0
      t.integer :deposit, default: 0

      t.string :canceled_reason
      t.timestamps
    end
  end
end
