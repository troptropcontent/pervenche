# frozen_string_literal: true
# typed: strict

module Billing
  class Address < T::Struct
    const :customer_id, String
    prop :last_name, T.nilable(String)
    prop :first_name, T.nilable(String)
    prop :company, T.nilable(String)
    prop :phone, T.nilable(String)
    prop :address, T.nilable(String)
    prop :city, T.nilable(String)
    prop :zipcode, T.nilable(String)
    prop :country, T.nilable(String)

    def update(attributes)
      updated_billing_address_data = Billable::Clients::ChargeBee::Customer.update_billing_address(customer_id,
                                                                                                   attributes)
      self.last_name = updated_billing_address_data['last_name']
      self.first_name = updated_billing_address_data['first_name']
      self
    end

    def to_partial_path
      'billing/addresses/address'
    end

    def customer
      Customer.find(customer_id)
    end
  end
end
