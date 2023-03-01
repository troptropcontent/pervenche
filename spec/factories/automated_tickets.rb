FactoryBot.define do
  factory :automated_ticket do
    user
    service
    type {}
    rate_option_client_internal_id { 'MyString' }
    license_plate { 'MyString' }
    zipcode { 'MyString' }
    weekdays { [6] }
    accepted_time_units { ['days'] }
    payment_method_client_internal_id { 'MyString' }
  end
end
