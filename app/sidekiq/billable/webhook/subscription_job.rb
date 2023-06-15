# frozen_string_literal: true
# typed: strict

module Billable
  module Webhook
    class SubscriptionJob
      extend T::Sig
      include Sidekiq::Job
      include Mixins::Subscription::TrialEndReminder
      include Mixins::Subscription::Created

      sig do
        params(
          webhook_type: String,
          serialized_content: String
        ).returns(T.untyped)
      end
      def perform(webhook_type, serialized_content)
        action = webhook_type.delete_prefix('subscription_')
        content = JSON.parse(serialized_content)
        case action
        when 'created'
          process_created_webhook(content)
        when 'trial_end_reminder'
          process_trial_end_reminder_webhook(content)
        end
      end
    end
  end
end
