# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTickets::ResumeSubscription, type: :actor do
  subject { described_class.call(automated_ticket:) }
  let!(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :set_up, user:, service:, charge_bee_subscription_id: '198XFzTmAvvY5a3S')
  end
  let(:user) { FactoryBot.create(:user, chargebee_customer_id: 'BTM8hcTebF5hX7WD') }
  let(:service) { FactoryBot.create(:service, :without_validations, user:) }
  describe '.call' do
    context 'when the customer does not have a valid payment_method' do
      it 'raises an error', vcr: true do
        expect { subject }.to raise_error(ServiceActor::Failure)
      end
    end
    context 'when the customer have a valid payment_method' do
      it 'raises an error', vcr: true do
        expect { subject }.to raise_error(ServiceActor::Failure)
      end
    end
  end
end
