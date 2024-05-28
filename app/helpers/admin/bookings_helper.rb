module Admin::BookingsHelper
  def status_badge status
    case status
      when "pending" , "payment_pending"
        content_tag(:span, "⏳")
      when "confirmed", "paid"
        content_tag(:span, "✔️")
      when "cancelled"
        content_tag(:span, "❌")
      when "refunded"
        content_tag(:span, "refunded", class: "text-danger fw-bold")
    end
  end
end
