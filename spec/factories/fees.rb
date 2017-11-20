FactoryBot.define do
  factory :fee do
    price { Faker::Number.between(1, 200) }
    storage_facility { FactoryBot.build(:storage_facility) }
    fee_type { Fee.fee_types.keys.sample }
  end
end
