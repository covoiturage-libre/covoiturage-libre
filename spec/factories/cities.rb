# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :city do
    name  { "Gotham City #{City.count}" }
    lat   { City.count }
    lon   { City.count }
  end
end
