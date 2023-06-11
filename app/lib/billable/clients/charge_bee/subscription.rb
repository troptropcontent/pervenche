# frozen_string_literal: true
# typed: strict

module Billable
  module Clients
    module ChargeBee
      class Subscription
        class << self
          extend T::Sig

          sig { params(subscription_id: String).returns(T.untyped) }
          def find(subscription_id)
            response = get_client(path: "/#{subscription_id}")
            return unless response.status == 200

            build_subscription(subscription_hash: response.body)
          end

          sig { params(filter_params: T::Hash[String, T.untyped]).returns(T::Array[Billable::Subscription::Base]) }
          def list(filter_params: {})
            response = get_client(params: filter_params)
            return [] unless response.status == 200

            subscriptions_array = response.body.fetch('list')
            subscriptions_array.map! do |subscription_hash|
              build_subscription(subscription_hash:)
            end
          end

          private

          sig { params(path: String, params: T::Hash[String, T.untyped]).returns(Faraday::Response) }
          def get_client(path: '', params: {})
            Http::Client.get(
              url: "https://#{Billable.billing_client_configuration[:site]}.chargebee.com/api/v2/subscriptions#{path}",
              params:,
              user: Billable.billing_client_configuration[:api_key],
              raise_error: false,
              logger: false
            )
          end

          sig { params(subscription_hash: T::Hash[String, T.untyped]).returns(Billable::Subscription::Base) }
          def build_subscription(subscription_hash:)
            subscription_data = subscription_hash['subscription']
            Billable::Subscription::Base.new(
              subscription_billing_client_internal_id: subscription_data['id'],
              trial_end: (Time.zone.at(subscription_data['trial_end']).to_datetime if subscription_data['trial_end']),
              customer_billing_client_internal_id: subscription_data['customer_id'],
              status: subscription_data['status'],
              next_billing_at: Time.zone.at(subscription_data['next_billing_at']).to_datetime,
              deleted: subscription_data['deleted'],
              plans: subscription_data['subscription_items'].map do |plan_data|
                       { plan_id: plan_data['item_price_id'], amount: plan_data['amount'] }
                     end,
              due_invoices_count: subscription_data['due_invoices_count']
            )
          end
        end
      end
    end
  end
end