# frozen_string_literal: true
# typed: strict

module Billable
  module Clients
    module ChargeBee
      class Invoice
        class << self
          extend T::Sig

          sig { params(subscription_id: String).returns(T.untyped) }
          def list(subscription_id:)
            filter_params ||= { 'subscription_id[is]' => subscription_id }
            response = get_client(params: filter_params)
            return unless response.status == 200

            response.body
          end

          sig { params(invoice_id: String).returns(T.untyped) }
          def pdf(invoice_id:)
            response = Http::Client.post(
              url: "https://#{Billable.billing_client_configuration[:site]}.chargebee.com/api/v2/invoices/#{invoice_id}/pdf",
              user: Billable.billing_client_configuration[:api_key],
              raise_error: false,
              logger: false
            )

            return unless response.status == 200

            response.body
          end

          private

          sig do
            params(params: T.nilable(T::Hash[String, T.untyped]), path: T.nilable(String)).returns(Faraday::Response)
          end
          def get_client(params: {}, path: nil)
            Http::Client.get(
              params:,
              url: "https://#{Billable.billing_client_configuration[:site]}.chargebee.com/api/v2/invoices#{path}",
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
