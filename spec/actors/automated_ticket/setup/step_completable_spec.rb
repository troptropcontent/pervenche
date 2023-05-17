# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Setup::StepCompletable, type: :actor do
  subject { described_class.call(automated_ticket:, step:).step_completable }
  let(:automated_ticket) do
    FactoryBot.build(:automated_ticket, setup_step_step_completed, user:, service:)
  end
  let(:setup_step_step_completed) { :with_vehicle }
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end
  let(:step) { :vehicle }

  describe '.call' do
    describe 'when the step is completable' do
      context 'when the step is completed but the next one is not' do
        it 'returns true' do
          expect(subject).to eq(true)
        end
      end
      context 'when the step is not completed and the previous one is' do
        let(:step) { :localisation }
        it 'returns true' do
          expect(subject).to eq(true)
        end
      end
    end
    describe 'when the step is not completable' do
      context 'when the step is not completed and the previous one is not completed aswell' do
        let(:step) { :rate_option }
        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
      context 'when the next step is already completed' do
        let(:step) { :kind }
        it 'returns true' do
          expect(subject).to eq(false)
        end
      end
    end
  end
end
