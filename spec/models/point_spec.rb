require 'rails_helper'

describe Point, type: :model do

  describe "validations" do
    it "should not accepts decimal price" do
      point = Point.new(price: 1.23)
      expect(point).to_not be_valid
      expect(point.errors[:price].any?).to be true
    end

    it "should accepts rounded price" do
      point = Point.new(price: 0)
      expect(point.errors[:price].empty?).to be true
    end
  end

end
