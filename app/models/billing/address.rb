# frozen_string_literal: true
# typed: strict

module Billing
  class Address < T::Struct
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    const :customer_id, String
    prop :last_name, T.nilable(String)
    prop :first_name, T.nilable(String)
    prop :company, T.nilable(String)
    prop :phone, T.nilable(String)
    prop :address, T.nilable(String)
    prop :city, T.nilable(String)
    prop :zipcode, T.nilable(String)
    prop :country, T.nilable(String)

    def update!(attributes)
      updated_billing_address_data = Billable::Clients::ChargeBee::Customer.update_address(customer_id,
                                                                                           attributes)

      raise Errors::UnprocessableEntity, 'The address could not been saved' if updated_billing_address_data.nil?

      self.last_name = updated_billing_address_data['last_name']
      self.first_name = updated_billing_address_data['first_name']
      self.address = updated_billing_address_data['line1']
      self.city = updated_billing_address_data['city']
      self.company = updated_billing_address_data['company']
      self.zipcode = updated_billing_address_data['zipcode']
      self
    end

    def customer
      Customer.find(customer_id)
    end

    def persisted?
      true
    end
  end
end
