# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip do
    points { build_list(:point, 4) }
    # users { create_list(:user, 1) }
  end
end
