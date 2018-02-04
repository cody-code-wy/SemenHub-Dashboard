FactoryBot.define do
  factory :registration do
    registrar { FactoryBot.build(:registrar) }
    animal { FactoryBot.build(:animal) }
    registration { Faker::Code.asin }
    ai_certification { Faker::Code.asin }
    note { Faker::Hipster.sentence }
  end
end
