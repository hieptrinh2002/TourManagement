require "faker"

FactoryBot.define do
  factory :tour_type do
    type_name {Faker::Team.name}
    ancestry {nil}
  end

  factory :review do
    rating { Faker::Number.within(range: 1..5) }
    comment { Faker::Address.state }
    association :tour
    association :user
  end

  factory :user do
    role {1}
    first_name {"Admin"}
    last_name {"Trinh"}
    email {"admin@railstutorial.org"}
    phone {"083504567"}
    address {"HCM"}
    date_of_birth {"2003-01-01"}
    password {"123456"}
    password_confirmation {"123456"}
    confirmed_at {Time.now}
  end

  factory :tour do
    tour_name {Faker::Address.state}
    city {Faker::Address.city}
    tour_destination {Faker::Address.full_address}
    description {Faker::Lorem.paragraph(sentence_count: 2)}
    price {Faker::Number.decimal(l_digits: 3, r_digits: 3)}
    day_duration {Faker::Number.within(range: 1..29)}
    min_guests {5}
    max_guests {Faker::Number.within(range: 11..50)}
    deposit_percent {Faker::Number.between(from: 1.0, to: 30.0)}
    association :tour_type
  end
end
