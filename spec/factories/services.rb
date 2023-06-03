FactoryBot.define do
  factory :service do
    user
    kind { 'pay_by_phone' }
    name { 'MyString' }
    username { 'MyString' }
    password { 'MyString' }

    trait :without_validations do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
