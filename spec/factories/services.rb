FactoryBot.define do
  factory :service do
    user
    kind { 'pay_by_phone' }
    name { 'MyString' }
    username { 'MyString' }
    password { 'MyString' }
  end
end
