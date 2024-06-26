class Review < ApplicationRecord
  REVIEW_ATTRIBUTES = %i(
    rating
    comment
    tour_id
    user_id
  ).freeze

  belongs_to :tour
  belongs_to :user
  validates :rating, presence: true,
                     numericality: {greater_than: Settings.digit_0,
                                    less_than: Settings.digit_6}
  validates :comment, presence: true, if: ->{rating.blank?}
  validates :rating, presence: true, if: ->{comment.blank?}
  scope :order_by_create_at, ->{order(created_at: :desc)}

  scope :total_ratings_by_star, lambda {|n|
    where(rating: n.nil? ? Settings.invalid_star_num : n).count
  }

  scope :total_ratings, (lambda do
    where(rating: Settings.digit_1..Settings.digit_5).count
  end)

  scope :average_rating, (lambda do
    average(:rating).to_f.round(Settings.digit_1)
  end)

  scope :by_rating, (lambda do |n|
    where(rating: n.nil? ? Settings.invalid_star_num : n)
  end)

  scope :average_rating_per_tour, (lambda do
    joins(:tour).group("tours.tour_name").average(:rating)
  end)
end
