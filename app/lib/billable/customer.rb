# frozen_string_literal: true
# typed: strict

module Billable
  module Customer
    extend T::Sig
    class Base < T::Struct
      const :customer_billing_client_internal_id, String
      const :email, String
      const :last_name, T.nilable(String)
      const :first_name, T.nilable(String)
      const :payment_method_valid, T::Boolean
      const :payment_method_status, String
      const :deleted, T::Boolean
    end
    sig { params(filter_params: T::Hash[String, T.untyped]).returns(T::Array[Billable::Customer::Base]) }
    def self.list(filter_params: {})
      customer_client.list(filter_params:)
    end

    sig { params(customer_billing_client_internal_id: String).returns(T.nilable(Billable::Customer::Base)) }
    def self.find(customer_billing_client_internal_id)
      customer_client.find(customer_billing_client_internal_id)
    end

    sig { returns(T.class_of(Billable::Clients::ChargeBee::Customer)) }
    def self.customer_client
      # later here we can switch the Customer depending on Billable.billing_client
      Billable::Clients::ChargeBee::Customer
    end

    sig { returns(T.nilable(Billable::Customer::Base)) }
    def customer
      @customer ||= Billable::Customer.find(customer_billing_client_internal_id)
    end
  end
end
