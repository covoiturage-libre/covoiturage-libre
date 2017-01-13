# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip do
    points { create_list(:points, 4) }
    users { create_list(:user, 1) }
  end
end
