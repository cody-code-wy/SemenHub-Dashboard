FactoryBot.define do
  factory :animal do
    name { Faker::Superhero.name }
    owner { FactoryBot.build(:user) }
    breed { FactoryBot.build(:breed) }
    private_herd_number { Faker::Number.number(15) }
    dna_number { Faker::Number.number(10) }
    description { Faker::Hipster.sentence }
    notes { Faker::Hipster.sentence }
    is_male { [true, false].sample }

    trait :with_registrations do
      registrations { build_list :registration, 3 }
    end

    trait :with_skus do
      skus { build_list :sku, 10 }
    end

    trait :with_dam do
      dam { FactoryBot.build(:animal, is_male: false, breed: breed) }
    end

    trait :with_sire do
      sire { FactoryBot.build(:animal, is_male: true, breed: breed) }
    end
  end
end
