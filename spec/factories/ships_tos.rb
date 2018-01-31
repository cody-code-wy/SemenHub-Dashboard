FactoryBot.define do
  factory :ships_to do
    country { Country.all.sample }
    sku { FactoryBot.build(:sku) }
  end
end
