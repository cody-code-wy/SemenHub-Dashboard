FactoryBot.define do
  factory :registrar do
    breed { FactoryBot.build(:breed) }
    address { FactoryBot.build(:address) }
    name { Faker::Lorem.words(2).join(' ') }
    phone_primary { Faker::PhoneNumber.phone_number }
    phone_secondary { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    website { Faker::Internet.url }
    note { Faker::Lorem.paragraph }
  end
end
