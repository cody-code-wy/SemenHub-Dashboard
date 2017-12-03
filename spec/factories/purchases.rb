FactoryBot.define do
  factory :purchase do
    user { FactoryBot.build(:user) }
    state { Purchase.states.keys.sample }

    trait :paid do
      state :paid
      authorization_code { Faker::Number.number(6) }
      transaction_id { Faker::Number.number(11) }
    end
  end
end
