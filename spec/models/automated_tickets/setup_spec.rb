require 'rails_helper'

RSpec.describe AutomatedTickets::Setup, type: :model do
  subject { described_class.new(automated_ticket) }
  let!(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :with_zipcodes, user:, service:)
  end
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end
  describe '#last_completed_step' do
    context 'when all steps are not completed' do
      it 'returns the last completed step' do
        expect(subject.last_completed_step.name).to eq(:zipcodes)
      end
    end
  end
  describe '#reset_to(step)' do
    let(:step) do
      AutomatedTickets::SetupStep.new(:vehicle)
    end
    context 'when the automated_ticket is ready' do
      let!(:automated_ticket) do
        FactoryBot.create(:automated_ticket, :set_up, user:, service:)
      end
      it 'does not do anything' do
        automated_attributes_before_reset = automated_ticket.attributes
        subject.reset_to(step)
        expect(automated_ticket.reload.attributes).to eq(automated_attributes_before_reset)
      end
    end

    context 'when the automated_ticket is not ready' do
      it 'reset the relevant attributes to there default vales' do
        subject.reset_to(step)
        expect(automated_ticket.reload.zipcodes).to eq([])
      end
    end
  end
end
