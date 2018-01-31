FactoryBot.define do
  factory :permission_assignment do
    role { FactoryBot.build(:role) }
    permission { FactoryBot.build(:permission) }
  end
end
