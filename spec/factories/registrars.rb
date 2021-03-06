FactoryBot.define do
  factory :registrar do
    breed { FactoryBot.build(:breed) }
    address { FactoryBot.build(:address) }
    name { Faker::Company.name }
    phone_primary { Faker::PhoneNumber.phone_number }
    phone_secondary { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    website { Faker::Internet.url }
    note { Faker::Lorem.paragraph }

    trait :with_registrations do
      registrations { FactoryBot.build_list(:registration, 2) }
    end
  end
end
