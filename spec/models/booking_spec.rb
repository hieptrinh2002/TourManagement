# spec/models/booking_spec.rb
require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      booking = FactoryBot.build(:booking)
      expect(booking).to be_valid
    end

    it "is not valid without a status" do
      booking = FactoryBot.build(:booking, status: nil)
      expect(booking).not_to be_valid
    end

    it "is not valid without a number_of_guests" do
      booking = FactoryBot.build(:booking, number_of_guests: nil)
      expect(booking).not_to be_valid
    end

    it "is not valid if number_of_guests less than Settings.booking.min_guests" do
      booking = FactoryBot.build(:booking, number_of_guests: Settings.booking.min_guests - 1)
      expect(booking).not_to be_valid
    end

    it "is not valid without a started_date" do
      booking = FactoryBot.build(:booking, started_date: nil)
      expect(booking).not_to be_valid
    end
  end

  describe "enums" do
    it "defines enum for status" do
      is_expected.to define_enum_for(:status).with_values({ pending: 0, confirmed: 1, cancelled: 2, cancelled_by_user: 3 })
    end

    it "defines enum for payment_status" do
      is_expected.to define_enum_for(:payment_status).with_values({ payment_pending: 0, paid: 1, refunded: 2 })
    end
  end

  describe "methods" do
    describe "#calculate_total_price" do
      it "calculates total price based on only tour" do
        tour = FactoryBot.create(:tour, price: 500.0)
        booking = FactoryBot.build(:booking, tour: tour, number_of_guests: 3)

        booking.send(:calculate_total_price)

        expected_total_price = tour.price;
        expect(booking.total_price).to eq(expected_total_price)
      end

      it "applies voucher discount if voucher code is present" do
        tour = FactoryBot.create(:tour, price: 500.0)
        voucher = FactoryBot.create(:voucher, percent_discount: 20)
        booking = FactoryBot.build(:booking, tour: tour, voucher_code: voucher.code)

        booking.send(:calculate_total_price)

        discounted_price = tour.price * (1 - voucher.percent_discount / 100.0)
        expect(booking.total_price).to eq(discounted_price)
      end

      it "calculates deposit based on tour's deposit percent" do
        tour = FactoryBot.create(:tour, deposit_percent: 30)
        booking = FactoryBot.build(:booking, tour: tour)

        booking.send(:calculate_total_price)

        expected_deposit = booking.total_price * (tour.deposit_percent / 100.0)
        expect(booking.deposit).to be_within(1).of(expected_deposit)
      end
    end
  end
end
