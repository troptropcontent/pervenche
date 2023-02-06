FactoryBot.define do
  factory :automated_ticket do
    service { nil }
    type { "" }
    rate_option_client_internal_id { "MyString" }
    license_plate { "MyString" }
    zipcode { "MyString" }
    quantity { 1 }
    time_unit { "MyString" }
    payment_method_client_internal_id { "MyString" }
  end
end
