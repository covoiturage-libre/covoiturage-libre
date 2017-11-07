require 'rails_helper'

describe PricesValidator, type: :model do
  describe '#validate' do

    it "should do nothing with empty object" do
      trip = Trip.new
      expect(PricesValidator.new.validate(trip)).to be true
      expect(trip.errors.empty?).to be true
    end

    it "should add error with object with missing price" do
      trip = Trip.new(points: [
        Point.new,
        Point.new
      ])
      expect(PricesValidator.new.validate(trip)).to be false
      expect(trip.errors[:price].any?).to be true
    end

    it "should add error with object with unordered prices" do
      trip = Trip.new(points: [
        Point.new,
        Point.new(price: 20),
        Point.new(price: 30)
      ], price: 10.7) # will override 30
      expect(PricesValidator.new.validate(trip)).to be false
      expect(trip.errors[:price].any?).to be true
      expect(trip.price).to eq 10.7
    end

    it "should do nothing with object with well ordered prices" do
      trip = Trip.new(points: [
        Point.new,
        Point.new(price: 2.7),
        Point.new(price: 10.3),
        Point.new(price: 10.3),
        Point.new
      ], price: 10.8)
      expect(PricesValidator.new.validate(trip)).to be true
      expect(trip.errors[:price].empty?).to be true
      expect(trip.price).to eq 10.8
    end

  end
end
