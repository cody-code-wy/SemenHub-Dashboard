FactoryBot.define do
  factory :country do
    name { Faker::Address.country }
    alpha_2 { Faker::Address.country_code }
    alpha_3 { Faker::Address.country_code_long }

    trait :with_addresses do
      addresses { [FactoryBot.build(:address), FactoryBot.build(:address)] }
    end
  end
end