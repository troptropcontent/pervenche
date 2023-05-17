# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Setup::StepCompleted, type: :actor do
  subject { described_class.call(automated_ticket:, step:).step_completed }
  let(:automated_ticket) do
    FactoryBot.build(:automated_ticket, :with_vehicle, user:, service:)
  end
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end
  let(:step) { :vehicle }
  describe '.call' do
    context 'when the step is completed' do
      it 'returns true' do
        expect(subject).to eq(true)
      end
    end
    context 'when the step is not completed' do
      let(:step) { :localisation }
      it 'returns true' do
        expect(subject).to eq(false)
      end
    end
  end
end
