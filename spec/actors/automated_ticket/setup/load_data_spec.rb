# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
require 'support/shared_context/service_stubs'

RSpec.describe AutomatedTicket::Setup::LoadData, type: :actor do
  include_context 'a user with a service with an automated ticket', :payment_methods
  include_context 'a stubed service'
  let(:step) { :service }
  subject { described_class.call(automated_ticket:, step:) }
  describe '.call' do
    describe 'step' do
      context 'service' do
        let(:expected_data) do
          { services: [[service.name, service.id]] }
        end
        it 'loads the correct data' do
          expect(subject.data).to eq(expected_data)
        end
      end
      context 'vehicle' do
        let(:step) { :vehicle }
        let(:expected_data) do
          { vehicles: [
            { client_internal_id: 'a_fake_client_id',
              license_plate: 'a_fake_license_plate',
              vehicle_description: 'a_fake_name',
              vehicle_type: 'electric_motorcycle' }
          ] }
        end
        it 'loads the correct data' do
          expect(subject.data).to eq(expected_data)
        end
      end
      context 'rate_option' do
        let(:step) { :rate_option }
        let(:expected_data) do
          { rate_options: [
            { accepted_time_units: %w[minutes hours],
              client_internal_id: '1085252721',
              free: true,
              name: 'shared rate option',
              type: 'CUSTOM' }
          ] }
        end
        it 'loads the correct data' do
          expect(subject.data).to eq(expected_data)
        end
      end
      context 'payment_methods' do
        let(:step) { :payment_methods }
        let(:expected_data) do
          { payment_methods: [
            { anonymised_card_number: '6156',
              client_internal_id: 'fake-payment-methof-id-9654e1084eb1',
              payment_card_type: 'visa' }
          ] }
        end
        it 'loads the correct data' do
          expect(subject.data).to eq(expected_data)
        end
      end
    end
  end
end
