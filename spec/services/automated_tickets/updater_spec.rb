# frozen_string_literal: true

require 'rails_helper'
module AutomatedTickets
  RSpec.describe Resumer do
    subject { described_class.call(automated_ticket, automated_ticket_params) }
    let(:automated_ticket_params) do
      ActionController::Parameters.new(params).require(:automated_ticket).permit(*AutomatedTicketsController::PERMITED_PARAMS)
    end
    let(:automated_ticket) { FactoryBot.create(:automated_ticket) }
    let!(:automated_ticket) do
      FactoryBot.create(:automated_ticket, :set_up, user:, service:, active: false, charge_bee_subscription_id: 'BTcd4sThFVEMHRSz')
    end
    let(:automated_ticket_active_attribute) { true }
    let(:user) { FactoryBot.create(:user) }
    let(:service) { FactoryBot.create(:service, :without_validations, user:) }

    context 'when the subscription resume fails' do
      before do
        allow(ActiveSupport::Notifications).to receive(:instrument).with('faraday.errors', anything)
        allow(ActiveSupport::Notifications).to receive(:instrument).with('factory_bot.run_factory', anything)
      end
      it 'raises and error, notify error and does not do anything', vcr: true do
        expect(ActiveSupport::Notifications).to receive(:instrument).with(
          'charge_bee.subscription_resume_error',
          {
            message: 'Chargebee - Cannot resume subscription in Active state. Only Paused subscriptions can be resumed.',
            automated_ticket_id: automated_ticket.id,
            user_email: automated_ticket.user.email
          }
        )
        expect { subject }.to raise_error(Billing::Errors::UnprocessableEntity)
        expect(automated_ticket.subscription.status).to eq('active')
      end
    end
    context 'when the subscription resume is successfull' do
      it 'resumes the subscription', vcr: true do
        expect(subject).to eq(nil)
      end
      icke
    end
  end
end
