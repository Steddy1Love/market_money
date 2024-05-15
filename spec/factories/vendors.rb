FactoryBot.define do
  factory :vendor do
    market_vendor
    market 
    name { "MyString" }
    description { "MyString" }
    contact_name { "MyString" }
    contact_phone { "MyString" }
    credit_accepted { false }
  end
end
