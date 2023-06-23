class Billing::Subscription < T::Struct
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  const :customer_id, String
  const :plan_id, String
  const :holder_id, T.nilable(Integer)
  const :holder_type, T.nilable(String)
  prop :amount, T.nilable(Integer)
  prop :client_id, T.nilable(String)
  prop :started_at, T.nilable(DateTime)
  prop :trial_ends_at, T.nilable(DateTime)
  prop :status, T.nilable(String)
  prop :next_billing_at, T.nilable(DateTime)
  prop :deleted, T.nilable(T::Boolean)
  prop :due_invoices_count, T.nilable(Integer)
  prop :client_data, T::Hash[String, T.untyped]

  class << self
    def find(id)
      client_data = Billable::Clients::ChargeBee::Subscription.find(id)
      raise Errors::NotFound, "Subscription with id #{id} could not be found" if client_data.nil?

      build_subscription_from_hash(client_data)
    end

    def list(filter_params: filters)
      client_data = Billable::Clients::ChargeBee::Subscription.list(filter_params:)
      client_data['list'].map do |subscription_hash|
        build_subscription_from_hash(subscription_hash)
      end
    end

    private

    def build_subscription_from_hash(subscription_hash)
      new(
        customer_id: subscription_hash.dig('subscription', 'customer_id'),
        client_id: subscription_hash.dig('subscription', 'id'),
        holder_id: subscription_hash.dig('subscription', 'cf_holder_id'),
        holder_type: subscription_hash.dig('subscription', 'cf_holder_type'),
        plan_id: subscription_hash.dig('subscription', 'subscription_items', 0, 'item_price_id'),
        started_at: Time.zone.at(subscription_hash.dig('subscription', 'started_at')).to_datetime,
        trial_ends_at: Time.zone.at(subscription_hash.dig('subscription', 'trial_end')).to_datetime,
        amount: subscription_hash.dig('subscription', 'subscription_items').sum { |item| item['amount'] },
        status: subscription_hash.dig('subscription', 'status'),
        next_billing_at: Time.zone.at(subscription_hash.dig('subscription', 'next_billing_at')).to_datetime,
        deleted: subscription_hash.dig('subscription', 'deleted'),
        due_invoices_count: subscription_hash.dig('subscription', 'due_invoices_count'),
        client_data: subscription_hash
      )
    end
  end

  def holder
    return if holder_id.nil? && holder_type.nil

    holder_type.constantize.find(holder_id)
  end
end
