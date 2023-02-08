FactoryBot.define do
  factory :user do
    email { 'myemail@example.com' }
    password { 'pervenche' }
    password_confirmation { 'pervenche' }
  end
end
