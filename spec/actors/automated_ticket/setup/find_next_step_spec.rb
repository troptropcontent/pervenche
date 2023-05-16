# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Setup::FindNextStep, type: :actor do
  describe '.call' do
    subject { described_class.call(automated_ticket:, step:).next_step }
    let(:automated_ticket) do
      automated_ticket = FactoryBot.build(:automated_ticket, :with_vehicle, user:, service:)
      automated_ticket.setup_step = step
    end
    let(:user) { FactoryBot.create(:user) }
    let(:service) do
      service = FactoryBot.build(:service, user_id: user.id)
      service.save(validate: false)
      service
    end
    let(:step) { :vehicle }
    context 'when there is a next step' do
      it 'returns it' do
        expect(subject).to eq(:localisation)
      end
    end
    context 'when there is no next step' do
      let(:step) { :subscription }
      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end
  end
end
