require "rails_helper"

RSpec.describe Tour, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      tour = FactoryBot.build(:tour)
      expect(tour).to be_valid
    end

    it "is not valid without tour name" do
      tour = FactoryBot.build(:tour, tour_name: nil)
      expect(tour).not_to be_valid
    end
    it "is not valid without city" do
      tour = FactoryBot.build(:tour, city: nil)
      expect(tour).not_to be_valid
    end
    it "is not valid without tour destination" do
      tour = FactoryBot.build(:tour, tour_destination: nil)
      expect(tour).not_to be_valid
    end
    it "is not valid without description" do
      tour = FactoryBot.build(:tour, description: nil)
      expect(tour).not_to be_valid
    end
    it "is not valid without price" do
      tour = FactoryBot.build(:tour, price: nil)
      expect(tour).not_to be_valid
    end
    it "is not valid if price less than 0" do
      tour = FactoryBot.build(:tour, price: -1)
      expect(tour).not_to be_valid
    end
    it "is not valid if price equal to 0" do
      tour = FactoryBot.build(:tour, price: 0)
      expect(tour).not_to be_valid
    end
    it "is not valid without day duration" do
      tour = FactoryBot.build(:tour, day_duration: nil)
      expect(tour).not_to be_valid
    end
    it "is not valid without min guests" do
      tour = FactoryBot.build(:tour, min_guests: nil)
      expect(tour).not_to be_valid
    end
    it "is not valid if min guests less than 0" do
      tour = FactoryBot.build(:tour, min_guests: -1)
      expect(tour).not_to be_valid
    end
    it "is not valid if min guests equal to 0" do
      tour = FactoryBot.build(:tour, min_guests: 0)
      expect(tour).not_to be_valid
    end
    it "is not valid without max guests" do
      tour = FactoryBot.build(:tour, max_guests: nil)
      expect(tour).not_to be_valid
    end
    it "is not valid if max guests less than 0" do
      tour = FactoryBot.build(:tour, max_guests: -1)
      expect(tour).not_to be_valid
    end
    it "is not valid if max guests equal to 0" do
      tour = FactoryBot.build(:tour, max_guests: 0)
      expect(tour).not_to be_valid
    end
    it "is not valid without min guests greater than max guests" do
      tour = FactoryBot.build(:tour, min_guests: 6, max_guests: 5)
      expect(tour).not_to be_valid
    end
    it "is not valid without deposit percent" do
      tour = FactoryBot.build(:tour, deposit_percent: nil)
      expect(tour).not_to be_valid
    end
    it "is not valid if deposit percent less than 0" do
      tour = FactoryBot.build(:tour, deposit_percent: -1)
      expect(tour).not_to be_valid
    end
    it "is not valid if deposit percent greater than 100" do
      tour = FactoryBot.build(:tour, deposit_percent: -1)
      expect(tour).not_to be_valid
    end
  end
end
