require 'rails_helper'

describe Trip, type: :model do

  before(:all) do
    city = City.create!

    @trip = Trip.create!(
      departure_date: Date.today,
      departure_time: Time.now,
      price: 12,
      title: 'M',
      name: 'John',
      email: 'yolo@example.com',
      seats: 2,
      comfort: 'comfort',

      points: [
        Point.new(kind: 'From', lat: 1.23, lon: 1.24, city: city),
        Point.new(kind: 'Step', lat: 1.24, lon: 1.25, city: city, rank: 1, price: 4),
        Point.new(kind: 'Step', lat: 1.25, lon: 1.26, city: city, rank: 2, price: 5),
        Point.new(kind: 'To', lat: 1.83, lon: 1.84, city: city)
      ]
    )
  end

  describe '.from_to' do
    it "should return each matching Trip only one time and with the nearest points" do
      results = Trip.from_to(1.24, 1.23, 1.25, 1.24)
                    .where(id: @trip.id)

      expect(results).to be_a ActiveRecord::Relation
      expect(results.map { |result|
        result.attributes.slice(
          'id', 'price',
          'point_a_id', 'point_a_price',
          'point_b_id', 'point_b_price'
        )
      }).to eq [{
        'id' => @trip.id,
        'price' => @trip.price,
        'point_a_id' => @trip.points[1].id,
        'point_a_price' => @trip.points[1].price,
        'point_b_id' => @trip.points[2].id,
        'point_b_price' => @trip.points[2].price
      }]
    end
  end

  describe '.from_only' do
    # TODO: only one time and with the nearest from point
    it "should return each matching Trip multiple time with different from point" do
      results = Trip.from_only(1.25, 1.24)
                    .where(id: @trip.id)

      expect(results).to be_a ActiveRecord::Relation
      expect(results.map { |result|
        result.attributes.slice(
          'id', 'price',
          'point_a_id', 'point_a_price'
        )
      }).to eq [{
        'id' => @trip.id,
        'price' => @trip.price,
        'point_a_id' => @trip.points[1].id,
        'point_a_price' => @trip.points[1].price
      }]
    end
  end

  describe '.to_only' do
    it "should return each matching Trip only one time with different to point" do
      results = Trip.to_only(1.26, 1.25)
                    .where(id: @trip.id)

      puts results.map(&:to_json)
      puts results.map(&:attributes)
      expect(results).to be_a ActiveRecord::Relation
      expect(results.map { |result|
        result.attributes.slice(
          'id', 'price',
          'point_b_id', 'point_b_price'
        )
      }).to eq [{
        'id' => @trip.id,
        'price' => @trip.price,
        'point_b_id' => @trip.points[2].id,
        'point_b_price' => @trip.points[2].price
      }]
    end
  end

end
