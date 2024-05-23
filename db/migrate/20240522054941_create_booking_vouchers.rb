class CreateBookingVouchers < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_vouchers do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :voucher, null: false, foreign_key: true

      t.timestamps
    end
    add_index :booking_vouchers, [:booking_id, :voucher_id], unique: true
  end
end
