FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    spouse_name { Faker::Name.first_name }
    email { Faker::Internet.unique.email }
    phone_primary { Faker::PhoneNumber.phone_number }
    phone_secondary { Faker::PhoneNumber.phone_number }
    website { Faker::Internet.domain_name }
    mailing_address { FactoryBot.build(:address) }
    billing_address { FactoryBot.build(:address) }
    payee_address { FactoryBot.build(:address) }
    password { Faker::Internet.password(8) }
    password_confirmation { password }
    temp_pass false

    trait :with_commission do
      commission { FactoryBot.build(:commission, :without_user) }
    end

    trait :with_animals do
      animals { [FactoryBot.build(:animal),FactoryBot.build(:animal)] }
    end
  end
end
