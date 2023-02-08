FactoryBot.define do
  factory :automated_ticket do
    user
    service
    type {}
    rate_option_client_internal_id { 'MyString' }
    license_plate { 'MyString' }
    zipcode { 'MyString' }
    minutes { 1 }
    client_time_unit { 'MyString' }
    payment_method_client_internal_id { 'MyString' }
  end
end
