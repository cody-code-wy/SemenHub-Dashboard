FactoryBot.define do
  factory :breed do
    breed_name { Faker::Team.creature }

    trait :with_registrars do
      registrars { [ FactoryBot.build(:registrar), FactoryBot.build(:registrar) ] }
    end
  end
end
