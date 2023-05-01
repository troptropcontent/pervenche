class Webhooks::ChargeBee::Handlers::SubscriptionJob
  include Sidekiq::Job

  def perform(webhook_type, serialized_content)
    action = webhook_type.delete_prefix('subscription_')
    content = JSON.parse(serialized_content)
    case action
    when 'created'
      handle_subscription_created_webhook(content)
    end
  end

  private

  def handle_subscription_created_webhook(content)
    automated_ticket_id = content.dig('subscription', 'cf_automated_ticket_id')
    charge_bee_subscription_id = content.dig('subscription', 'id')
    automated_ticket = AutomatedTicket.find(automated_ticket_id)
    automated_ticket.update!(charge_bee_subscription_id:)
    ActiveSupport::Notifications.instrument 'charge_bee.subscription_created', {
      type: content.dig('subscription', 'subscription_items', 0, 'item_price_id'),
      amount: (content.dig('subscription', 'subscription_items', 0, 'amount') / 100),
      trial_ends: DateTime.strptime(content.dig('subscription', 'trial_end').to_s, '%s'),
      automated_ticket_id: content.dig('subscription', 'cf_automated_ticket_id')
    }
  end
end
