# frozen_string_literal: true

require 'rails_helper'
module AutomatedTickets
  RSpec.describe Pauser do
    subject { described_class.call(automated_ticket) }
    let(:automated_ticket) { FactoryBot.create(:automated_ticket) }
    let!(:automated_ticket) do
      FactoryBot.create(:automated_ticket, :set_up, user:, service:, active: automated_ticket_active_attribute, charge_bee_subscription_id: 'BTcd4sThFVEMHRSz')
    end
    let(:automated_ticket_active_attribute) { false }
    let(:user) { FactoryBot.create(:user) }
    let(:service) { FactoryBot.create(:service, :without_validations, user:) }

    context 'when the subscription pause fails' do
      before do
        allow(ActiveSupport::Notifications).to receive(:instrument).with('faraday.errors', anything)
        allow(ActiveSupport::Notifications).to receive(:instrument).with('factory_bot.run_factory', anything)
      end
      it 'raises and error, notify error and does not do anything', vcr: true do
        expect(ActiveSupport::Notifications).to receive(:instrument).with(
          'charge_bee.subscription_pause_error',
          {
            message: 'Chargebee - Cannot pause subscription in Paused state. Only Active, Non-renewing subscriptions can be paused.',
            automated_ticket_id: automated_ticket.id,
            user_email: automated_ticket.user.email
          }
        )
        expect { subject }.to raise_error(Billing::Errors::UnprocessableEntity)
      end
    end
    context 'when the subscription pause is successfull' do
      it 'updates the active attribute', vcr: true do
        expect(subject).to be(nil)
      end
    end
  end
end
