FactoryBot.define do
  factory :user do
    email { 'myemail@example.com' }
    password { 'pervenche' }
    password_confirmation { 'pervenche' }
    chargebee_customer_id { 'BTcd3pTchKzWzG2u' }
  end
end
