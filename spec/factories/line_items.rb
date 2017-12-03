FactoryBot.define do
  factory :line_item do
    name { Faker::Lorem.word }
    value { Faker::Number.decimal(2,3) }
    purchase { FactoryBot.build(:purchase) }
  end
end
