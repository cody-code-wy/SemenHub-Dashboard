FactoryBot.define do
  factory :role do
    name { Faker::Lorem.word }

    trait :with_permissions do
      permissions { [ FactoryBot.build(:permission), FactoryBot.build(:permission) ] }
    end

    trait :with_users do
      users { [ FactoryBot.build(:user), FactoryBot.build(:user) ] }
    end
  end
end
