FactoryBot.define do
  factory :breed do
    breed_name { Faker::Team.creature }
  end
end
