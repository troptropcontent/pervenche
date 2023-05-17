# frozen_string_literal: true

FactoryBot.define do
  factory :automated_ticket do
    user
    service
    active { true }

    trait :with_kind do
      kind { 'electric_motorcycle' }
    end

    trait :with_vehicle do
      with_kind
      license_plate { 'CL12345KK' }
      vehicle_type { 'electric_motorcycle' }
    end

    trait :with_localisation do
      with_kind
      with_vehicle
      localisation { 'paris' }
    end

    trait :with_zipcodes do
      with_kind
      with_vehicle
      with_localisation
      zipcodes { %w[75018 75019 75020] }
    end

    trait :with_rate_option do
      with_kind
      with_vehicle
      with_localisation
      with_zipcodes
      rate_option_client_internal_id { 'bhkjhlkjhkljhlkjhlkjhkjhkzeizeoiruzeo' }
      accepted_time_units { ['days'] }
    end

    trait :with_weekdays do
      with_kind
      with_vehicle
      with_localisation
      with_zipcodes
      with_rate_option
      weekdays { [1, 2, 3, 4, 5, 6] }
    end

    trait :with_payment_methods do
      with_kind
      with_vehicle
      with_localisation
      with_zipcodes
      with_rate_option
      with_weekdays
      payment_method_client_internal_ids { ['rytrtt88ppezoezpeop'] }
    end

    trait :with_charge_bee_subscription_id do
      with_kind
      with_vehicle
      with_localisation
      with_zipcodes
      with_rate_option
      with_weekdays
      with_payment_methods
      charge_bee_subscription_id { ['hgjhkghjghgghgkhgk'] }
    end

    trait :set_up do
      with_kind
      with_vehicle
      with_localisation
      with_zipcodes
      with_rate_option
      with_weekdays
      with_payment_methods
      with_charge_bee_subscription_id
      status { :ready }
    end
  end
end
