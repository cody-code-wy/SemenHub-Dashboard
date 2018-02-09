FactoryBot.define do
  factory :purchase do
    user { FactoryBot.build(:user) }
    state { Purchase.states.keys.sample }

    trait :paid do
      state :paid
      authorization_code { Faker::Number.number(6) }
      transaction_id { Faker::Number.number(11) }
    end

    trait :with_shipments do
      shipments { build_list(:shipment, 3) }
    end

    trait :with_line_items do
      line_items { build_list(:line_item, 10) }
    end

    trait :with_inventory_transactions do
      inventory_transactions { build_list(:inventory_transaction, 2) }
    end

    trait :for_test_transaction do
      line_items { build_list(:line_item, 1, name: 'test transaction', value: Faker::Number.between(1,50)) }
      state :invoiced
    end
  end
end
