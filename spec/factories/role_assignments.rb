FactoryBot.define do
  factory :role_assignment do
    user { FactoryBot.build(:user) }
    role { FactoryBot.build(:role) }
  end
end
