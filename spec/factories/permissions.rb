FactoryBot.define do
  factory :permission do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
  end
end
