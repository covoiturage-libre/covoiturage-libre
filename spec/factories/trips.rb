# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :trip do
    departure_date    { Time.zone.today }
    departure_time    { Time.now }
    price             { rand(7..20) }
    title             'M'
    name              'John'
    email             'yolo@example.com'
    seats             { rand(1..5) }
    comfort           'comfort'

    points {
      cities_count = 5
      cities = City.last(cities_count)
      cities += create_list(:city, cities_count - cities.size) if cities.size < cities_count

      [
        Point.new(kind: 'From', lat: 1.23, lon: 1.24, city: cities.pop.name),
        Point.new(kind: 'Step', lat: 1.24, lon: 1.25, city: cities.pop.name, rank: 1, price: 4),
        Point.new(kind: 'Step', lat: 1.25, lon: 1.26, city: cities.pop.name, rank: 2, price: 5),
        Point.new(kind: 'Step', lat: 1.25, lon: 1.27, city: cities.pop.name, rank: 3, price: 6)
      ].first(rand(1..4)) +
        [Point.new(kind: 'To', lat: 1.83, lon: 1.84, city: cities.pop.name)]

      # build_list(:point, 4)
    }

    # users { create_list(:user, 1) }
  end
end
