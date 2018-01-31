FactoryBot.define do
  factory :inventory_transaction do
    quantity { Faker::Number.between(1,100) }
    sku { FactoryBot.build(:sku) }

    trait :with_purchases do
      purchases { build_list(:purchase, 2) }
    end
  end
end
