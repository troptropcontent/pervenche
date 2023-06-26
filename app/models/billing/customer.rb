# frozen_string_literal: true

module Billing
  class Customer < T::Struct
    const :client_id, String
    const :email, String
    const :deleted, T::Boolean
    const :taxability, String
    prop :customer_data, T::Hash[String, T.untyped]

    def self.find(id)
      customer_data = Billable::Clients::ChargeBee::Customer.find(id)
      raise Errors::NotFound, "Customer with id #{id} does not exist" if customer_data.nil?

      new(
        client_id: customer_data.dig('customer', 'id'),
        email: customer_data.dig('customer', 'email'),
        deleted: customer_data.dig('customer', 'deleted'),
        taxability: customer_data.dig('customer', 'taxability'),
        customer_data:
      )
    end

    def update(attributes)
      Billable::Clients::ChargeBee::Customer.update(client_id, attributes)
      self.class.find(client_id)
    end

    def address
      address_data = customer_data.dig('customer', 'billing_address') || {}
      Address.new(
        customer_id: client_id,
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

    def payment_method
      payment_method_data = customer_data['card'] || {}
      PaymentMethod.new(
        customer_id: client_id,
        status: payment_method_data['status'],
        last_four_digits: payment_method_data['last4'],
        card_type: payment_method_data['card_type'],
        funding_type: payment_method_data['funding_type'],
        expiry_month: payment_method_data['expiry_month'],
        expiry_year: payment_method_data['expiry_year']
      )
    end

    def subscriptions
      @subscriptions ||= Billing::Subscription.list(filter_params: { 'customer_id[is]' => client_id })
    end
  end
end
