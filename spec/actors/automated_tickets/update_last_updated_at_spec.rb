# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTickets::UpdateLastUpdatedAt, type: :actor do
  subject { described_class.call(automated_ticket:) }
  let!(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :set_up, user:, service:, charge_bee_subscription_id: '198XFzTmAvvY5a3S')
  end
  let(:user) { FactoryBot.create(:user, chargebee_customer_id: 'BTM8hcTebF5hX7WD') }
  let(:service) { FactoryBot.create(:service, :without_validations, user:) }
  describe '.call' do
    it 'set last_activated_at to now', vcr: true do
      subject
      expect(automated_ticket.reload.last_activated_at).to be_within(1.second).of(Time.zone.now)
    end
  end
end
