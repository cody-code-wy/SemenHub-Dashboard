FactoryBot.define do
  factory :permission do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    trait :with_roles do
      roles { [ FactoryBot.build(:role), FactoryBot.build(:role) ] }
    end
  end
end
