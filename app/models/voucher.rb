class Voucher < ApplicationRecord
  VOUCHER_ATTRIBUTES = %i(
    expiry_date
    code
    percent_discount
    min_total_price
  ).freeze

  has_many :booking_vouchers, dependent: :destroy
  validate :validate_expiry_date
  validate :validate_unique_code, on: %i(new update)

  scope :ordered, (lambda do
    select("vouchers.*,
            CASE WHEN expiry_date >= NOW() THEN 0 ELSE 1 END AS order_field")
    .order("order_field, created_at ASC")
  end)
  scope :available, (lambda do
    where("expiry_date >= NOW()").order(expiry_date: :asc)
  end)
  scope :expired, (lambda do
    where("expiry_date < NOW()").order(expiry_date: :asc)
  end)
  scope :by_status, (lambda do |status|
    case status
    when "all"
      ordered
    when "available"
      available
    when "expired"
      expired
    else
      all
    end
  end)
  scope :by_code, (lambda do |code|
    where("code LIKE ?", "%#{sanitize_sql_like(code)}%") if code.present?
  end)
  scope :by_percent_discount, (lambda do |percent_discount|
    where("percent_discount >= ?", percent_discount.presence ||
    Settings.voucher.search.percent_discount)
  end)
  scope :by_min_total_price, (lambda do |min_total_price|
    where("min_total_price >= ?", min_total_price.presence ||
    Settings.voucher.search.min_total_price)
  end)
  scope :with_code, ->(code){where(code:)}

  def is_expired?
    expiry_date < Time.zone.now
  end

  private

  def validate_expiry_date
    return unless expiry_date.present? && expiry_date <= Time.zone.now

    errors.add(:expiry_date, I18n.t("flash.voucher.wrong_expiry_date"))
  end

  def validate_unique_code
    return if Voucher.with_code(code).blank?

    errors.add(:code, I18n.t("flash.voucher.code_exist"))
  end
end
