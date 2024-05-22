class CreateVouchers < ActiveRecord::Migration[7.0]
  def change
    create_table :vouchers do |t|
      t.datetime :expiry_date
      t.string :code
      t.decimal :percent_discount
      t.decimal :min_total_price

      t.timestamps
    end
  end
end
