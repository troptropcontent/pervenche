module Billing
  module Webhook
    class PaymentJob
      include Sidekiq::Job
      include Mixins::Payment::SourceAdded
      def perform(webhook_type, serialized_content)
        action = webhook_type.delete_prefix('payment_')
        content = JSON.parse(serialized_content)
        case action
        when 'source_added'
          process_source_added_webhook(content)
        end
      end
    end
  end
end
