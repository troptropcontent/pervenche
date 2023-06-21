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
  end
end
