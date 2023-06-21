# frozen_string_literal: true

module Billing
  class Customer < T::Struct
    class Error < StandardError; end
    const :billing_client_id, String
    const :email, String
    const :deleted, T::Boolean

    def self.find(id)
      customer_data = Billable::Clients::ChargeBee::Customer.find(id)
      raise Error, "Customer with id #{id} does not exist" if customer_data.nil?

      new(
        billing_client_id: customer_data.dig('customer', 'id'),
        email: customer_data.dig('customer', 'email'),
        deleted: customer_data.dig('customer', 'deleted')
      )
    end

    def billing_address
      customer_data = Billable::Clients::ChargeBee::Customer.find(billing_client_id)
      raise Error, "Customer with id #{billing_client_id} does not exist" if customer_data.nil?

      address_data = customer_data.dig('customer', 'billing_address')
      Address.new(
        customer_id: billing_client_id,
        last_name: address_data['last_name'],
        first_name: address_data['first_name'],
        company: address_data['company'],
        phone: address_data['phone'],
        address: address_data['line1'],
        city: address_data['city'],
        zipcode: address_data['zip'],
        country: address_data['country']
      )
    end
  end
end
