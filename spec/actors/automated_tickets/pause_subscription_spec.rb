# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTickets::PauseSubscription, type: :actor do
  subject { described_class.call(automated_ticket:) }
  let!(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :set_up, user:, service:, charge_bee_subscription_id: 'BTcd4sThFVEMHRSz')
  end
  let(:user) { FactoryBot.create(:user) }
  let(:service) { FactoryBot.create(:service, :without_validations, user:) }
  describe '.call' do
    context 'when the subscription pause request fails' do
      it 'raises an error', vcr: true do
        expect { subject }.to raise_error(ServiceActor::Failure)
      end
    end
    context 'when the subscription pause request is successfull' do
      it 'does not fails', vcr: true do
        expect { subject }.not_to raise_error(ServiceActor::Failure)
      end
    end
  end
end
