class Voucher < ApplicationRecord
  has_many :booking_vouchers, dependent: :destroy
end
