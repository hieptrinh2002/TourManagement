all_tour = TourType.create(type_name: "All Tour", ancestry: nil)

beach_tour = TourType.create(type_name: "Beach Tour", ancestry: all_tour.id)
mountain_tour = TourType.create(type_name: "Mountain Tour", ancestry: all_tour.id)

TourType.create(type_name: "North Beach", ancestry: beach_tour.id)
TourType.create(type_name: "South Beach", ancestry: beach_tour.id)
TourType.create(type_name: "Lowland Mountain", ancestry: mountain_tour.id)
TourType.create(type_name: "Highland Mountain", ancestry: mountain_tour.id)


30.times do |n|
	tour_name = Faker::Australia.state
	city = Faker::Address.city
	tour_destination = Faker::Address.full_address
	description = Faker::Lorem.paragraph(sentence_count: 2)
	price = Faker::Number.decimal(l_digits: 3, r_digits: 3)
	day_duration = Faker::Number.within(range: 1..29)
	start_date = Faker::Date.between(from: '2024-09-23', to: '2025-09-23')
	end_date = start_date + day_duration.days
	tour_type_id = Faker::Number.within(range: 3..6)
	Tour.create!(tour_name:, city:, tour_destination:, description:, price:, day_duration:, start_date:, end_date:, tour_type_id:)
end

User.create!(role: 1, first_name:"Admin", last_name:"Trinh",
            email:"admin@railstutorial.org", phone:"083504567", address:"HCM",
            date_of_birth: "2003-01-01",
            password: "123456",
            password_confirmation:"123456",
            activated: true,
            activated_at: Time.zone.now)

User.create!(role: 0, first_name:"User", last_name:"Trinh",
            email:"User@railstutorial.org", phone:"083504567", address:"HN",
            date_of_birth: "2003-01-01",
            password: "123456",
            password_confirmation:"123456",
            activated: true,
            activated_at: Time.zone.now)

100.times do
  User.create!(
    role: 0,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address,
    date_of_birth: Faker::Date.between(from: '1980-01-01', to: '2003-12-31'),
    password: '123456',
    password_confirmation: '123456',
    activated: true,
    activated_at: Time.zone.now
  )
end

# Create flights
100.times do
  flight = Flight.create!(
    airline_brand: Faker::Company.name,
    flight_number: Faker::Alphanumeric.alphanumeric(number: 6).upcase,
    departure_time: Faker::Time.forward(days: 23, period: :morning),
    arrival_time: Faker::Time.forward(days: 23, period: :afternoon),
    origin_place: Faker::Address.city,
    destination: Faker::Address.city
  )

  # Create tickets for each flight
  ['economy_class', 'business_class', 'first_class'].each do |ticket_class|
    FlightTicket.create!(
      flight: flight,
      ticket_class: ticket_class,
      price: Faker::Commerce.price(range: 50.0..500.0)
    )
  end
end

# Seed Bookings
40.times do
  booking = Booking.create!(
    tour_id: Faker::Number.between(from: 1, to: 30),
    user_id: Faker::Number.between(from: 2, to: 100),
    flight_ticket_id: Faker::Number.between(from: 2, to: 32),
    phone_number: Faker::PhoneNumber.phone_number,
    number_of_guests: Faker::Number.between(from: 2, to: 15),
    started_date: Faker::Date.forward(days: 30),
    total_price: Faker::Commerce.price(range: 100.0..1000.0),
    payment_status: ['paid', 'payment_pending', 'refunded'].sample,
    confirmed_date: Faker::Date.backward(days: 10),
    cancellation_date: nil,
    status: ['pending', 'confirmed', 'cancelled'].sample
  )
end
