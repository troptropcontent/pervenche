FactoryBot.define do
  factory :ticket_request do
    automated_ticket 
    payment_method_client_internal_id { "MyString" }
    requested_on { "2023-02-28 19:49:20" }
  end
end
