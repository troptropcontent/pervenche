# frozen_string_literal: true
# typed: strict

module Billable
  module Customer
    extend T::Sig
    class Error < StandardError; end
    class RecordNotFound < Error; end
    sig { params(filter_params: T::Hash[String, T.untyped]).returns(T::Array[Billable::Customer::Base]) }
    def self.list(filter_params: {})
      customer_client.list(filter_params:)
    end

    sig { params(customer_billing_client_internal_id: String).returns(Billable::Customer::Base) }
    def self.find(customer_billing_client_internal_id)
      customer = customer_client.find(customer_billing_client_internal_id)
      unless customer
        raise RecordNotFound,
              "Customer with an id of #{customer_billing_client_internal_id} does not exists"
      end

      customer
    end

    sig { returns(T.class_of(Billable::Clients::ChargeBee::Customer)) }
    def self.customer_client
      # later here we can switch the Customer depending on Billable.billing_client
      Billable::Clients::ChargeBee::Customer
    end

    sig { params(customer_billing_client_internal_id: String, redirect_url: String).returns(T.nilable(String)) }
    def self.update_payment_method_hosted_page_url(customer_billing_client_internal_id, redirect_url:)
      # later here we can switch the Customer depending on Billable.billing_client
      customer_client.update_payment_method_hosted_page_url(customer_billing_client_internal_id, redirect_url:)
    end

    sig { returns(T.nilable(Billable::Customer::Base)) }
    def customer
      @customer ||= T.let(Billable::Customer.find(customer_billing_client_internal_id),
                          T.nilable(Billable::Customer::Base))
    end
  end
end
