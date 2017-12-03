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
  end
end
