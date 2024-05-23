class BookingVoucher < ApplicationRecord
  belongs_to :booking
  belongs_to :voucher
end
