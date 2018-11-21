FactoryBot.define do
  factory :event do
    start Date.today
    finish 10.days.from_now
    timezone 'CET'
    user_id 1
    name { Faker::Lorem.word }
    description { Faker::Lorem.word }
    location 'Office1'
    association :creator, factory: :user, username: "admin"
  end
end
