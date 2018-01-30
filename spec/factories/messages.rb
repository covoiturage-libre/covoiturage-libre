# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :message do
    trip

    sender_name { "Toto" }
    sender_email { "toto@example.com" }
    body { "Coucou" }
  end
end
