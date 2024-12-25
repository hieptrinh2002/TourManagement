require "faker"

# spec/factories/booking.rb

FactoryBot.define do
  factory :voucher do
    expiry_date { Faker::Date.between(from: "2024-07-23", to: "2025-09-23") }
    code { Faker::Alphanumeric.alpha(number: 6) }
    min_total_price { Faker::Number.decimal(l_digits: 3, r_digits: 3) }
    percent_discount { Faker::Number.between(from: 10, to: 30) }
    max_uses { Faker::Number.between(from: 50, to: 100) }
    used { Faker::Number.between(from: 4, to: 40) }
  end


  factory :booking do
    tour { create(:tour) }  # Đảm bảo rằng tour đã được tạo và gán giá trị
    user { create(:user) }
    flight_ticket_id { Faker::Number.between(from: 2, to: 32) }
    phone_number { Faker::PhoneNumber.phone_number }
    number_of_guests { Faker::Number.between(from: 2, to: 15) }
    started_date { Faker::Date.forward(days: 30) }
    total_price { Faker::Commerce.price(range: 0..10000000.0) }
    payment_status { ['paid', 'payment_pending', 'refunded'].sample }
    confirmed_date { Faker::Date.backward(days: 10) }
    cancellation_date { nil }
    voucher_code { "" }
    status { ['pending', 'confirmed', 'cancelled'].sample }
    canceled_reason { "" }
  end
end
