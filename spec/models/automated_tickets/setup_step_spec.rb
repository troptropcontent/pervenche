# frozen_string_literal: true

require 'rails_helper'
module AutomatedTickets
  RSpec.describe SetupStep, type: :model do
    let(:automated_ticket) do
      FactoryBot.create(:automated_ticket, automated_ticket_setup_step, user:, service:)
    end
    let(:automated_ticket_setup_step) { :with_zipcodes }
    let(:user) { FactoryBot.create(:user) }
    let(:service) { FactoryBot.build(:service, :without_validations, user_id: user.id) }

    describe 'class methods' do
      describe '.next_completable_step' do
        let(:automated_ticket_setup_step) { :with_kind }
        context 'when there is a next completable step' do
          it 'it retrns the next completable step' do
            next_completable_step = described_class.next_completable_step(automated_ticket)
            expect(next_completable_step.name).to eq(:vehicle)
          end
        end
        context 'when there is no next completable step' do
          let(:automated_ticket_setup_step) { :with_subscription }
          it 'it retrns the next completable step' do
            next_completable_step = described_class.next_completable_step(automated_ticket)
            expect(next_completable_step).to be_nil
          end
        end
      end

      describe '.current_step(automated_ticket)' do
        AutomatedTicket.setup_steps.each do |step_name, _fields|
          context "#{step_name} step" do
            it 'it returns the last completed step' do
              automated_ticket = FactoryBot.build(:automated_ticket, "with_#{step_name}".to_sym, user:)
              current_step = described_class.current_step(automated_ticket)
              expect(current_step.name).to eq(step_name)
            end
          end
        end
      end

      describe '.previous_completable_step' do
        let(:automated_ticket_setup_step) { :with_service }
        context 'when some steps directly behind are auto completed' do
          it 'returns the last completable step' do
            previous_completable_step = described_class.previous_completable_step(automated_ticket)
            expect(previous_completable_step.name).to eq(:kind)
          end
        end
        context 'when some steps behind are not required' do
          let(:automated_ticket_setup_step) { :with_payment_methods }
          it 'returns the last completable step' do
            previous_completable_step = described_class.previous_completable_step(automated_ticket)
            expect(previous_completable_step.name).to eq(:rate_option)
          end
        end
        context 'when some steps directly behind are both not required or autocompleted' do
          let(:automated_ticket_setup_step) { :with_payment_methods }
          it 'returns the last completable step' do
            previous_completable_step = described_class.previous_completable_step(automated_ticket)
            expect(previous_completable_step.name).to eq(:zipcodes)
          end
        end

        context 'when the step behind is completable' do
          let(:automated_ticket_setup_step) { :with_vehicle }
          it 'returns the step behind' do
            previous_completable_step = described_class.previous_completable_step(automated_ticket)
            expect(previous_completable_step.name).to eq(:vehicle)
          end
        end
      end

      describe '.steps' do
        let(:expected_return) do
          [
            SetupStep.new(:service),
            SetupStep.new(:localisation),
            SetupStep.new(:kind),
            SetupStep.new(:vehicle),
            SetupStep.new(:zipcodes),
            SetupStep.new(:rate_option),
            SetupStep.new(:weekdays),
            SetupStep.new(:payment_methods),
            SetupStep.new(:subscription)
          ]
        end
        it 'returns all the steps as SetupStep instances' do
          expect(described_class.steps).to eq(expected_return)
        end
      end
    end

    describe 'instance methods' do
      subject { described_class.new(step_name) }
      let!(:step_name) { :vehicle }
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
      describe '#edit_path(automated_ticket)' do
        let(:expected_edit_path) { "/automated_tickets/#{automated_ticket.id}/setup/vehicle/edit" }
        context 'when automated_ticket is an Integer' do
          it 'returns the path to the setup step show' do
            expect(subject.edit_path(automated_ticket.id)).to eq(expected_edit_path)
          end
        end
        context 'when automated_ticket is an AutomatedTicket' do
          it 'returns the path to the setup step show' do
            expect(subject.edit_path(automated_ticket)).to eq(expected_edit_path)
          end
        end
      end
      describe '#name' do
        it 'returns the step name' do
          expect(subject.name).to eq(:vehicle)
        end
      end
      describe '#to_s' do
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
      describe '#uncompleted?(automated_ticket)' do
        context 'when the step is completed' do
          let!(:step_name) { :zipcodes }
          let(:automated_ticket_setup_step) { :with_zipcodes }
          it 'returns true' do
            expect(subject.uncompleted?(automated_ticket)).to be false
          end
        end
        context 'when the step is not completed' do
          let!(:step_name) { :zipcodes }
          let(:automated_ticket_setup_step) { :with_vehicle }
          it 'returns true' do
            expect(subject.uncompleted?(automated_ticket)).to be true
          end
        end
      end
      describe '#next' do
        context 'when there is a step after the current one' do
          let!(:step_name) { :vehicle }
          it 'returns the next step' do
            expect(subject.next.name).to eq(:zipcodes)
          end
        end
        context 'when there is no step after the current one' do
          let!(:step_name) { :subscription }
          it 'returns nil' do
            expect(subject.next).to be_nil
          end
        end
      end
      describe '#auto_completable?(automated_ticket)' do
        context 'when the step is auto_completable for the automated_ticket' do
          let!(:step_name) { :weekdays }
          it 'returns true' do
            expect(subject.auto_completable?(automated_ticket)).to be true
          end
        end
        context 'when the step is not auto_completable for the automated_ticket' do
          let!(:step_name) { :kind }
          it 'returns false' do
            expect(subject.auto_completable?(automated_ticket)).to be false
          end
        end
      end

      describe '#not_auto_completable?(automated_ticket)' do
        context 'when the step is auto_completable for the automated_ticket' do
          let!(:step_name) { :weekdays }
          it 'returns true' do
            expect(subject.not_auto_completable?(automated_ticket)).to be false
          end
        end
        context 'when the step is not auto_completable for the automated_ticket' do
          let!(:step_name) { :kind }
          it 'returns false' do
            expect(subject.not_auto_completable?(automated_ticket)).to be true
          end
        end
      end

      describe '#==(other)' do
        let(:first_step) { described_class.new(first_step_name) }
        let(:second_step) { described_class.new(second_step_name) }
        context 'when names are equal' do
          let(:first_step_name) { :vehicle }
          let(:second_step_name) { :vehicle }
          it 'returns true' do
            expect(first_step == second_step).to be true
          end
        end
        context 'when names are not equal' do
          let(:first_step_name) { :vehicle }
          let(:second_step_name) { :zipcodes }
          it 'returns false' do
            expect(first_step == second_step).to be false
          end
        end
      end
    end
  end
end
