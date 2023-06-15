# frozen_string_literal: true
# typed: strict

module Billable
  module Webhook
    module Mixins
      module Subscription
        module Created
          extend T::Sig
          sig { params(content: T.untyped).void }
          def process_created_webhook(content)
            automated_ticket_id = content.dig('subscription', 'cf_automated_ticket_id')
            charge_bee_subscription_id = content.dig('subscription', 'id')
            automated_ticket = AutomatedTicket.find(automated_ticket_id)
            automated_ticket.update!(charge_bee_subscription_id:)
            notify_subscription_creation(content, automated_ticket)
          end

          private

          sig { params(content: T::Hash[String, T.untyped], automated_ticket: AutomatedTicket).void }
          def notify_subscription_creation(content, automated_ticket)
            ActiveSupport::Notifications.instrument 'charge_bee.subscription_created', {
              type: content.dig('subscription', 'subscription_items', 0, 'item_price_id'),
              amount: (content.dig('subscription', 'subscription_items', 0, 'amount') / 100),
              trial_ends: DateTime.strptime(content.dig('subscription', 'trial_end').to_s, '%s'),
              automated_ticket_id: content.dig('subscription', 'cf_automated_ticket_id'),
              user_email: automated_ticket.user.email
            }
          end
        end
      end
    end
  end
end
