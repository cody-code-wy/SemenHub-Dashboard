FactoryBot.define do
  factory :shipment do
    purchase { FactoryBot.build(:purchase) }
    shipping_provider { Shipment.shipping_providers.keys.sample }
    location_name { Faker::Pokemon.location }
    account_name { Faker::Name.name }
    address { FactoryBot.build(:address) }
    origin_address { FactoryBot.build(:address) }
    origin_name { Faker::Lorem.words(2).join(' ') }
    origin_account { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
    trait :with_requested_date do
      requested_date { Faker::Date.forward(15) }
    end
    trait :with_tracking do
      tracking_number { Faker::Number.number(10) }
    end
  end
end
