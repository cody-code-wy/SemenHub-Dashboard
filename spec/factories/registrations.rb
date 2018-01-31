FactoryBot.define do
  factory :registration do
    registrar { FactoryBot.build(:registrar) }
    animal { FactoryBot.build(:animal) }
    registration { Faker::Lorem.words(5).join('') }
    ai_certification { Faker::Lorem.words(3).join('') }
    note { Faker::Lorem.words(15).join(' ') }
  end
end
