class BookingMailer < ApplicationMailer
  def reminder_email booking
    @booking = booking
    @user = @booking.user
    mail(to: @user.email, subject: I18n.t("booking_reminder_mailer.subject"))
  end
end
