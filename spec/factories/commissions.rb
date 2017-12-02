FactoryBot.define do
  factory :commission do
    user { FactoryBot.build(:user) }
    commission_percent { Faker::Number.between(10,100) }

    trait :without_user do
      user nil
    end
  end
end
