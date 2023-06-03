# frozen_string_literal: true

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

  describe '#reset_to_unsaved(step)' do
    let(:step) do
      AutomatedTickets::SetupStep.new(:vehicle)
    end
    it 'reset the relevant attributes to there default vales but do not save the record' do
      subject.reset_to_unsaved(step)
      expect(automated_ticket.zipcodes).to eq([])
      expect(automated_ticket.reload.zipcodes).to eq(%w[75018 75019 75020])
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
