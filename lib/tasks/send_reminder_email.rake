# rake booking:send_reminder_email
namespace :booking do
  desc "Send reminder emails to users about their bookings"
  task send_reminder_email: :environment do
    Booking.starting_tomorrow.confirmed.each do |booking|
      BookingMailer.reminder_email(booking).deliver_now
    end
  end
end
