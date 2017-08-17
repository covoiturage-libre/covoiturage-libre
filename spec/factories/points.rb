# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :point do
    trip nil # Avoid loop
    city

    lat 12
    lng 2

    kind { Point::KINDS.sample }
    rank { rand(0..99) }
  end
end
