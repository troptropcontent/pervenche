# frozen_string_literal: true

require 'rails_helper'
module Billable
  module Webhook
    module Mixins
      module Subscription
        RSpec.describe Created do
          include Created
          describe 'process_created_webhook(content)' do
            let!(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, user:, service:, charge_bee_subscription_id: 'toto') }
            let(:user) { FactoryBot.create(:user, email: 'toto@example.com') }
            let(:service) { FactoryBot.create(:service, :without_validations, user_id: user.id) }
            let(:content) do
              {
                'subscription' => {
                  'cf_automated_ticket_id' => automated_ticket.id,
                  'id' => 'a_subscription_id',
                  'trial_end' => 1_688_083_200,
                  'subscription_items' => [
                    {
                      'amount' => 500,
                      'item_price_id' => 'a_item_price_id'
                    }
                  ]
                }
              }
            end
            let(:expected_notification_argments) do
              {
                type: 'a_item_price_id',
                amount: 5,
                trial_ends: DateTime.parse('2023-06-30'),
                automated_ticket_id: automated_ticket.id,
                user_email: 'toto@example.com'
              }
            end
            it 'updates the automated_ticket and notify' do
              expect(ActiveSupport::Notifications)
                .to(
                  receive(:instrument)
                    .with('charge_bee.subscription_created', expected_notification_argments)
                )
              process_created_webhook(content)
              expect(automated_ticket.reload.charge_bee_subscription_id).to eq('a_subscription_id')
            end
          end
        end
      end
    end
  end
end
