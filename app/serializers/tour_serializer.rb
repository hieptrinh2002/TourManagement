class TourSerializer < ActiveModel::Serializer
  attributes :id, :tour_name, :city, :tour_destination, :description, :price,
             :day_duration, :min_guests, :max_guests, :deposit_percent, :status
end
