FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryBot.define do
  factory :user do
    email { generate :email }
    password { 'pervenche' }
    password_confirmation { 'pervenche' }
    chargebee_customer_id { 'BTcd3pTchKzWzG2u' }
  end
end
