class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :rating, :comment, :tour_id, :user_id
end
