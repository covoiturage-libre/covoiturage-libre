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
      city = City.last || create(:city)

      [
        Point.new(kind: 'From', lat: 1.23, lon: 1.24, city: city),
        Point.new(kind: 'Step', lat: 1.24, lon: 1.25, city: city, rank: 1, price: 4),
        Point.new(kind: 'Step', lat: 1.25, lon: 1.26, city: city, rank: 2, price: 5),
        Point.new(kind: 'Step', lat: 1.25, lon: 1.27, city: city, rank: 2, price: 6)
      ].first(rand(1..4)) +
        [Point.new(kind: 'To', lat: 1.83, lon: 1.84, city: city)]

      # build_list(:point, 4)
    }

    # users { create_list(:user, 1) }
  end
end
