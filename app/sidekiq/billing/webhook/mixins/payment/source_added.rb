# frozen_string_literal: true
# typed: strict

module Billing
  module Webhook
    module Mixins
      module Payment
        module SourceAdded
          extend T::Sig
          sig { params(content: T.untyped).void }
          def process_source_added_webhook(content)
            customer = Billing::Customer.find(content.dig('customer', 'id'))
            subscriptions = customer.subscriptions

            subscriptions.each do |subscription|
              next if [subscription.status, subscription.cancel_reason] != %w[cancelled no_card]

              GenericJob.perform_async(
                'Billing::Subscription',
                'reactivate',
                { 'find_id' => subscription.client_id }
              )
            end
          end
        end
      end
    end
  end
end
