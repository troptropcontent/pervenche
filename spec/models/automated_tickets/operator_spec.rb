require 'rails_helper'

RSpec.describe AutomatedTickets::Operator, type: :model do
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
  describe '#next_completable_step' do
    context 'when there is at list one step completable' do
      it 'returns the next completable step' do
        expect(subject.next_completable_step.name).to eq(:rate_option)
      end
    end
    context 'when the automated ticket is completely setup' do
      let!(:automated_ticket) do
        FactoryBot.create(:automated_ticket, :set_up, user:, service:)
      end
      it 'returns nil' do
        expect(subject.next_completable_step).to be_nil
      end
    end
  end
end
