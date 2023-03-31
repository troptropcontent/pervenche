# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTickets::FindSimilarTicket, type: :actor do
  describe '.call' do
    context 'when a automated_ticket already covers on of the zipcodes' do
      let!(:automated_ticket_already_persisted) do
        FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes: ['75018'], status:)
      end
      let(:status) { :ready }
      let(:user) { FactoryBot.create(:user) }
      let(:service) do
        service = FactoryBot.build(:service, user_id: user.id)
        service.save(validate: false)
        service
      end
      let(:automated_ticket) do
        FactoryBot.build(:automated_ticket, :set_up, user:, service:, zipcodes: %w[75018 75017])
      end
      context 'already persisted ticket ready' do
        it 'returns the already covered zipcodes' do
          result = described_class.call(automated_ticket:)
          expect(result.zipcodes_already_covered).to eq(['75018'])
        end
      end
      context 'already persisted ticket is not ready' do
        let(:status) { :started }
        it 'returns the already covered zipcodes' do
          result = described_class.call(automated_ticket:)
          expect(result.zipcodes_already_covered).to eq([])
        end
      end
    end
  end
end
