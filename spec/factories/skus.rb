FactoryBot.define do
 factory :sku do
    private { rand < 0.1 }
    semen_type { Sku.semen_types.keys.sample }
    price_per_unit { Faker::Number.decimal(3,2) }
    semen_count { Sku.semen_counts.keys.sample }
    animal { FactoryBot.build(:animal) }
    storagefacility { FactoryBot.build(:storage_facility) }
    seller { FactoryBot.build(:user, payee_address: FactoryBot.build(:address)) }
    cost_per_unit nil
    cane_code nil
    has_percent false

    trait :with_inventory_transactions do
      inventory_transaction { FactoryBot.build_list(:inventory_transaction, 2) }
    end

    trait :with_countries do
       after :create do |sku|
         ships_tos = FactoryBot.create_list(:ships_to, 5, sku: sku)
         ships_tos.each { |st| sku.ships_to << st }
       end
       after :build do |sku|
         ships_tos = FactoryBot.build_list(:ships_to, 5, sku: sku)
         ships_tos.each { |st| sku.ships_to << st }
       end
    end

  end
end
