class UserVoucher < ApplicationRecord
  USER_VOUCHER_ATTRIBUTES = %i(
    user_id
    voucher_id
  ).freeze

  belongs_to :user
  belongs_to :voucher

  scope :used_by, (lambda do |user_id|
    where("user_id = ?", user_id)
  end)
end
