class Review < ApplicationRecord
  belongs_to :tour
  belongs_to :user

  validates :rating,
            presence: true,
            numericality: {greater_than_or_equal_to: Settings.review.min_rating,
                           less_than_or_equal_to: Settings.review.min_rating}
end
