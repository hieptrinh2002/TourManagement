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
end
