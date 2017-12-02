FactoryBot.define do
 factory :sku do
    private { rand < 0.1 }
    semen_type { Sku.semen_types.keys.sample }
    price_per_unit { Faker::Number.decimal(3,2) }
    semen_count { Sku.semen_counts.keys.sample }
    animal { FactoryBot.build(:animal) }
    storagefacility { FactoryBot.build(:storage_facility) }
    seller { FactoryBot.build(:user) }
    cost_per_unit nil
    cane_code nil
    has_percent false
  end
end
