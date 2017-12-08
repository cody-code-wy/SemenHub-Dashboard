FactoryBot.define do
  factory :animal do
    name { Faker::Name.name }
    owner { FactoryBot.build(:user) }
    breed { FactoryBot.build(:breed) }
    private_herd_number { Faker::Number.number(15) }
    dna_number { Faker::Number.number(10) }
    description { [ Faker::Lorem.paragraph, nil].sample }
    notes { [Faker::Lorem.paragraph, nil].sample }

    trait :with_registrations do
      registrations { build_list :registration, 3 }
    end

    trait :with_skus do
      skus { build_list :sku, 10 }
    end
  end
end
