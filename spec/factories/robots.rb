FactoryBot.define do
  factory :robot do
    service { nil }
    license_plate { "MyString" }
    payment_method { "MyString" }
    zipcode { "MyString" }
    duration { 1 }
  end
end
