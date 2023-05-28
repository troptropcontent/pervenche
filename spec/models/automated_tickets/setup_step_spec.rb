require 'rails_helper'

RSpec.describe AutomatedTickets::SetupStep, type: :model do
  subject { described_class.new(step_name) }
  let!(:step_name) { :vehicle }
  let!(:automated_ticket) do
    FactoryBot.create(:automated_ticket, automated_ticket_setup_step, user:, service:)
  end
  let(:automated_ticket_setup_step) { :with_zipcodes }
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end

  describe '#before?(another_step)' do
    context 'when the other step is after' do
      let(:another_step) { described_class.new(:zipcodes) }
      it 'returns false' do
        expect(subject.before?(another_step)).to be true
      end
    end
    context 'when the other step is before' do
      let(:another_step) { described_class.new(:kind) }
      it 'returns false' do
        expect(subject.before?(another_step)).to be false
      end
    end
  end

  describe '#<(another_step)' do
    context 'when the other step is after' do
      let(:another_step) { described_class.new(:zipcodes) }
      it 'returns false' do
        expect(subject < another_step).to be true
      end
    end
    context 'when the other step is before' do
      let(:another_step) { described_class.new(:kind) }
      it 'returns false' do
        expect(subject < another_step).to be false
      end
    end
  end

  describe '#index' do
    it 'returns the index of the step' do
      expect(subject.index).to eq(3)
    end
  end
  describe '#show_path(automated_ticket)' do
    let(:expected_show_path) { "/automated_tickets/#{automated_ticket.id}/setup/vehicle" }
    context 'when automated_ticket is an Integer' do
      it 'returns the path to the setup step show' do
        expect(subject.show_path(automated_ticket.id)).to eq(expected_show_path)
      end
    end
    context 'when automated_ticket is an AutomatedTicket' do
      it 'returns the path to the setup step show' do
        expect(subject.show_path(automated_ticket)).to eq(expected_show_path)
      end
    end
  end
  describe '#name' do
    it 'returns the step name' do
      expect(subject.name).to eq(:vehicle)
    end
  end
  describe '#tp_s' do
    it 'returns the step name as a string' do
      expect(subject.to_s).to eq('vehicle')
    end
  end

  describe '#completed?(automated_ticket)' do
    context 'when the step is completed' do
      let!(:step_name) { :zipcodes }
      let(:automated_ticket_setup_step) { :with_zipcodes }
      it 'returns true' do
        expect(subject.completed?(automated_ticket)).to be true
      end
    end
    context 'when the step is not completed' do
      let!(:step_name) { :zipcodes }
      let(:automated_ticket_setup_step) { :with_vehicle }
      it 'returns true' do
        expect(subject.completed?(automated_ticket)).to be false
      end
    end
  end
end
