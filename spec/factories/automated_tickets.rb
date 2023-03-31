# frozen_string_literal: true

FactoryBot.define do
  factory :automated_ticket do
    user
    service
    type { 'pay_by_phone' }

    trait :with_localisation do
      localisation { 'paris' }
    end

    trait :with_vehicle do
      license_plate { 'CL12345KK' }
      vehicle_type { 'electric_motorcycle' }
    end

    trait :with_zipcodes do
      zipcodes { %w[75018 75019 75020] }
    end

    trait :with_rate_option do
      rate_option_client_internal_id { 'bhkjhlkjhkljhlkjhlkjhkjhkzeizeoiruzeo' }
      accepted_time_units { ['days'] }
    end

    trait :with_weekdays do
      weekdays { [1, 2, 3, 4, 5, 6] }
    end

    trait :with_payment_methods do
      payment_method_client_internal_ids { ['rytrtt88ppezoezpeop'] }
    end

    trait :set_up do
      with_localisation
      with_vehicle
      with_zipcodes
      with_rate_option
      with_weekdays
      with_payment_methods
      status { :ready }
    end
  end
end
