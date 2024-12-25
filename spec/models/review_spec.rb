require "rails_helper"

RSpec.describe Review, type: :model do
  describe "validations" do
    it "validates presence of rating with correct message" do
      review = FactoryBot.build(:review, rating: nil)

      expect(review).to validate_presence_of(:rating).with_message("can't be blank")
    end

    it "validates numericality of rating greater than 0" do
      review = FactoryBot.build(:review, rating: -1)
      expect(review).to validate_numericality_of(:rating).is_greater_than(0)
    end

    it "validates numericality of rating less than 6" do
      review = FactoryBot.build(:review, rating: 6)
      expect(review).to validate_numericality_of(:rating).is_less_than(6)
    end

    it "is not valid without comment if rating is blank" do
      review = FactoryBot.build(:review, rating: nil, comment: nil)
      expect(review).not_to be_valid
    end
    it "is not valid without rating if comment is blank" do
      review = FactoryBot.build(:review, rating: nil, comment: "Nice tour")
      expect(review).not_to be_valid
    end
  end

  describe "scopes" do
    let(:tour) { FactoryBot.create(:tour) }
    let(:tour2) { FactoryBot.create(:tour) }
    let(:user) { FactoryBot.create(:user) }
    let!(:review1) { FactoryBot.create(:review, tour: tour, user: user, rating: 5, created_at: 2.days.ago) }
    let!(:review2) { FactoryBot.create(:review, tour: tour, user: user, rating: 4, created_at: 1.day.ago) }
    let!(:review3) { FactoryBot.create(:review, tour: tour2, user: user, rating: 3, created_at: 3.day.ago) }

    it "orders by created_at desc" do
      expect(Review.order_by_create_at).to eq([review2, review1, review3])
    end

    it "calculates total ratings by star" do
      expect(Review.total_ratings_by_star(5)).to eq(1)
    end

    it "calculates total ratings" do
      expect(Review.total_ratings).to eq(3)
    end

    it "calculates average rating" do
      expect(Review.average_rating).to eq(4)
    end

    it "filters by rating" do
      expect(Review.by_rating(5)).to include(review1)
      expect(Review.by_rating(5)).not_to include(review2)
      expect(Review.by_rating(5)).not_to include(review3)
    end

    it "calculates average rating per tour" do
      expect(Review.average_rating_per_tour).to eq({tour.tour_name => 4.5, tour2.tour_name => 3.0})
    end
  end
end
