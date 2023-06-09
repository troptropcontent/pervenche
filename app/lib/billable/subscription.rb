# frozen_string_literal: true
# typed: strict

module Billable
  module Subscription
    extend T::Sig
    class Base < T::Struct
      const :subscription_billing_client_internal_id, String
      const :trial_end, T.nilable(DateTime)
      const :customer_billing_client_internal_id, String
      const :status, String
      const :next_billing_at, DateTime
      const :deleted, T::Boolean
      const :plans, T::Array[T::Hash[Symbol, T.untyped]]
      const :due_invoices_count, Integer
    end
    sig { params(filter_params: T::Hash[String, T.untyped]).returns(T::Array[Billable::Subscription::Base]) }
    def self.list(filter_params: {})
      subscription_client.list(filter_params:)
    end

    sig { params(subscription_billing_client_internal_id: String).returns(T.nilable(Billable::Subscription::Base)) }
    def self.find(subscription_billing_client_internal_id)
      subscription_client.find(subscription_billing_client_internal_id)
    end

    sig { returns(T.class_of(Billable::Clients::ChargeBee::Subscription)) }
    def self.subscription_client
      # later here we can switch the subscription depending on Billable.billing_client
      Billable::Clients::ChargeBee::Subscription
    end

    sig { returns(T.nilable(Billable::Subscription::Base)) }
    def subscription
      @subscription ||= Billable::Subscription.find(subscription_billing_client_internal_id)
    end
  end
end
