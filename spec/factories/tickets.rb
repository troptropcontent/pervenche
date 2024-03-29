# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    zipcode { '75018' }
    starts_on { '2023-01-25 13:35:58' }
    ends_on { '2023-01-25 13:35:58' }
    license_plate { 'MyString' }
    cost_cents { 1 }
    automated_ticket
    client_internal_id { 'MyString' }
  end
end
