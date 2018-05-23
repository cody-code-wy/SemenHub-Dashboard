FactoryBot.define do
  factory :inventory_transaction do
    quantity { Faker::Number.between(1,100) }
    sku { FactoryBot.build(:sku) }

    trait :with_purchase do
      purchase { FactoryBot.create(:purchase) }
    end
  end
end
