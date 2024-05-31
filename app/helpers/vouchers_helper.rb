module VouchersHelper
  def voucher_status_options
    {
      t("vouchers.search.status_options.all") => "all",
      t("vouchers.search.status_options.available") => "available",
      t("vouchers.search.status_options.expired") => "expired"
    }
  end
end
