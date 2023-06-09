# frozen_string_literal: true
# typed: strict

module Billable
  class Customer < T::Struct
    class << self
      extend T::Sig
      sig { params(filter_params: T::Hash[String, T.untyped]).returns(T::Array[Billable::Customer]) }
      def list(filter_params: {})
        customer_client.list(filter_params:)
      end

      private

      sig { returns(T.class_of(Billable::Clients::ChargeBee::Customer)) }
      def customer_client
        #later here we can switch the Customer depending on Billable.billing_client
        Billable::Clients::ChargeBee::Customer
      end
    end

    const :customer_billing_client_internal_id, String
    const :email, String
    const :last_name, T.nilable(String)
    const :first_name, T.nilable(String)
    const :payment_method_valid, T::Boolean
    const :payment_method_status, String
    const :deleted, T::Boolean
  end
end
