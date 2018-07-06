FactoryBot.define do
  factory :user_alert do
    user nil
    started_at "2018-07-04 10:34:33"
    ended_at "2018-07-04 10:34:33"
    max_price 1.5
    smoking false
    min_seats 1
    min_comfort "MyString"
  end
end
