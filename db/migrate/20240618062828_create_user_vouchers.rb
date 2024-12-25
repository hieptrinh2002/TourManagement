class CreateUserVouchers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_vouchers do |t|
      t.integer :user_id
      t.integer :voucher_id
      t.timestamps
    end
  end
end
