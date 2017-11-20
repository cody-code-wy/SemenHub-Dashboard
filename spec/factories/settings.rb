FactoryBot.define do
  factory :setting do
    sequence(:setting){|n| Setting.settings.keys[n]}
    value { ["true", "false"].select }
  end
end
