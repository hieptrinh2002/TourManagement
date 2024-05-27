module Admin::BookingsHelper
  def status_badge status
    case status
    when "pending", "payment_pending"
      content_tag(:span, "⏳")
    when "confirmed", "paid"
      content_tag(:span, "✔️")
    when "cancelled"
      content_tag(:span, "❌")
    when "refunded"
      content_tag(:span, "refunded", class: "text-danger fw-bold")
    end
  end

  def booking_button btn_title, confirm_message, new_status, bootstrap_class
    button_to btn_title, admin_booking_path, method: :patch,
              class: bootstrap_class,
              params: {status: new_status},
              form: {data: {turbo_confirm: confirm_message}}
  end
end
