FactoryBot.define do
  factory :market_vendor do
    association :vendor
    association :market
  end
end