module Admin::BookingsHelper
  def status_badge status
    case status
    when "pending", "payment_pending"
      content_tag(:span, t("statuses.#{status}"),
                  class: "text-warning fw-bold")
    when "confirmed"
      content_tag(:span, t("statuses.confirmed"),
                  class: "text-success fw-bold")
    when "paid"
      content_tag(:span, t("statuses.paid"),
                  class: "text-success fw-bold")
    when "cancelled"
      content_tag(:span, t("statuses.cancelled"),
                  class: "text-danger fw-bold")
    when "refunded"
      content_tag(:span, t("statuses.refunded"),
                  class: "text-secondary fw-bold")
    when "not_yet_active"
      content_tag(:span, t("statuses.not_yet_active"),
                  class: "text-secondary fw-bold")
    when "active"
      content_tag(:span, t("statuses.active"),
                  class: "text-success fw-bold")
    when "removed"
      content_tag(:span, t("statuses.removed"),
                  class: "text-danger fw-bold")
    else
      content_tag(:span, status, class: "text-danger fw-bold")
    end
  end

  def booking_button btn_title, confirm_message, new_status, bootstrap_class
    button_to btn_title, admin_booking_path, method: :patch,
              class: bootstrap_class,
              params: {status: new_status},
              form: {data: {turbo_confirm: confirm_message}}
  end
end
