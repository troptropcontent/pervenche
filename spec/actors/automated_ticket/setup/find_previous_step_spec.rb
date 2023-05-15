# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Setup::FindPreviousStep, type: :actor do
  subject { described_class.call(automated_ticket:, step:).previous_step }
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
  let(:step) { :localisation }

  describe '.call' do
    context 'when there is a previous step' do
      it 'returns true' do
        expect(subject).to eq(:vehicle)
      end
    end
    context 'when there is no previous step' do
      let(:step) { :service }
      it 'returns true' do
        expect(subject).to eq(nil)
      end
    end
  end
end
