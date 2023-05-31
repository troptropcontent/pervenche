# frozen_string_literal: true

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
end
