FactoryBot.define do
  factory :address do
    line1 { Faker::Address.street_address }
    line2 { Faker::Address.secondary_address }
    postal_code { Faker::Address.postcode }
    city { Faker::Address.city }
    region { Faker::Address.state_abbr }
    alpha_2 'us'

    trait :known_good do #UPS Global Headquarters Address
      line1 '55 Glenlake Parkway NE'
      line2 nil
      postal_code '30328'
      city 'Atlanta'
      region 'GA'
      alpha_2 'us'
    end
  end
end
