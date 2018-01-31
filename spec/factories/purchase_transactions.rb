FactoryBot.define do
  factory :purchase_transaction do
    purchase { FactoryBot.build(:purchase) }
    inventory_transaction { FactoryBot.build(:inventory_transaction) }
  end
end
