require 'rails_helper'
RSpec.describe Billable::Webhook::SubscriptionJob, type: :job do
  let(:event_type) { 'subscription_created' }
  let(:webhook_content) do
    { 'some' => 'content' }
  end
  let(:serialized_webhook_content) { webhook_content.to_json }
  describe 'event_type' do
    context 'subscription_created' do
      let(:event_type) { 'subscription_created' }
      it 'calls the process_created_webhook method' do
        expect(subject).to receive(:process_created_webhook).with(webhook_content)
        subject.perform(event_type, serialized_webhook_content)
      end
    end
    context 'subscription_trial_end_reminder' do
      let(:event_type) { 'subscription_trial_end_reminder' }
      it 'calls the process_trial_end_reminder_webhook method' do
        expect(subject).to receive(:process_trial_end_reminder_webhook).with(webhook_content)
        subject.perform(event_type, serialized_webhook_content)
      end
    end
    context 'subscription_unknown_action' do
      let(:process_methods) do
        subject.public_methods.filter { |method| method.to_s.starts_with?('process') }
      end
      let(:event_type) { 'subscription_unknown_action' }
      it 'calls the process_trial_end_reminder_webhook method' do
        process_methods.each do |process_method|
          expect(subject).not_to receive(process_method)
        end
        subject.perform(event_type, serialized_webhook_content)
      end
    end
  end
end
