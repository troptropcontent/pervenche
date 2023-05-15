# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
require 'support/shared_context/service_stubs'

RSpec.describe AutomatedTicket::Setup::FindPath, type: :actor do
  subject { described_class.call(automated_ticket:, step:, previous_step_param:) }
  include_context 'a user with a service with an automated ticket', :payment_methods
  describe '.call' do
    describe 'step' do
      context 'service' do
        let(:step) { :service }
        let(:previous_step_param) { nil }
        let(:expected_path) { "/automated_tickets/#{automated_ticket.id}/setup/service" }
        it 'return the expected path for service step' do
          expect(subject.path).to eq(expected_path)
        end
      end
      context 'kind' do
        let(:step) { :kind }
        let(:previous_step_param) { :service }
        let(:expected_path) { "/automated_tickets/#{automated_ticket.id}/setup/kind?previous_step=service" }
        it 'return the expected path for localisation step' do
          expect(subject.path).to eq(expected_path)
        end
      end
      context 'localisation' do
        let(:step) { :localisation }
        let(:previous_step_param) { :kind }
        let(:expected_path) { "/automated_tickets/#{automated_ticket.id}/setup/localisation?previous_step=kind" }
        it 'return the expected path for localisation step' do
          expect(subject.path).to eq(expected_path)
        end
      end
      context 'vehicle' do
        let(:step) { :vehicle }
        let(:previous_step_param) { :localisation }
        let(:expected_path) { "/automated_tickets/#{automated_ticket.id}/setup/vehicle?previous_step=localisation" }
        it 'return the expected path for vehicle step' do
          expect(subject.path).to eq(expected_path)
        end
      end
      context 'zipcodes' do
        let(:step) { :zipcodes }
        let(:previous_step_param) { :vehicle }
        let(:expected_path) do
          "/automated_tickets/#{automated_ticket.id}/setup/zipcodes?localisation=paris&previous_step=vehicle"
        end
        it 'return the expected path for zipcodes step' do
          expect(subject.path).to eq(expected_path)
        end
      end
      context 'rate_option' do
        let(:step) { :rate_option }
        let(:previous_step_param) { :zipcodes }
        let(:expected_path) { "/automated_tickets/#{automated_ticket.id}/setup/rate_option?previous_step=zipcodes" }
        it 'return the expected path for rate_option step' do
          expect(subject.path).to eq(expected_path)
        end
      end
      context 'weekdays' do
        let(:step) { :weekdays }
        let(:previous_step_param) { :rate_option }
        let(:expected_path) { "/automated_tickets/#{automated_ticket.id}/setup/weekdays?previous_step=rate_option" }
        it 'return the expected path for weekdays step' do
          expect(subject.path).to eq(expected_path)
        end
      end
      context 'payment_methods' do
        let(:step) { :payment_methods }
        let(:previous_step_param) { :weekdays }
        let(:expected_path) { "/automated_tickets/#{automated_ticket.id}/setup/payment_methods?previous_step=weekdays" }
        it 'return the expected path for payment_methods step' do
          expect(subject.path).to eq(expected_path)
        end
      end
    end
  end
end
