FactoryBot.define do
  factory :image do
    url_format "http://via.placeholder.com/%dx300"
    animal { build :animal }
  end
end
