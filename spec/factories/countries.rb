FactoryBot.define do
  factory :country do
    name { Faker::Address.country }
    alpha_2 { Faker::Address.country_code }
    alpha_3 { Faker::Address.country_code_long }

    trait :with_addresses do
      addresses { [FactoryBot.build(:address), FactoryBot.build(:address)] }
    end

    trait :with_ships_tos do
      after :create do |country|
        country.ships_tos << FactoryBot.create_list(:ships_to, 5, country: country)
      end
      after :build do |country|
        country.ships_tos << FactoryBot.build_list(:ships_to, 5, country: country)
      end
    end
  end
end
