FactoryBot.define do
  factory :storage_facility do
    phone_number { Faker::PhoneNumber.phone_number }
    website { Faker::Internet.url }
    address { FactoryBot.build(:address) }
    name { Faker::Pokemon.move }
    email { Faker::Internet.email }
    shipping_provider { Shipment.shipping_providers.keys.sample }
    straws_per_shipment { Faker::Number.between(10,50) }
    admin_required false # default to false to make it more usable

    trait :with_adjustments do
      out_adjust { Faker::Number.between(10,30) }
      in_adjust { Faker::Number.between(10,30) }
    end

    trait :with_fees do
      fees { [ FactoryBot.build(:fee), FactoryBot.build(:fee) ] }
    end

    trait :with_skus do
      skus { build_list :sku, 10 }
    end
  end
end
