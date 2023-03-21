# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'

RSpec.describe AutomatedTicket::Setup::Updater::CompleteAlreadyCompletableSteps, type: :actor do
  include_context 'a user with a service with an automated ticket'
  subject { described_class.call(automated_ticket:) }
  describe '.call' do
    let(:automated_ticket_service) {}
    let(:automated_ticket_payment_method_client_internal_id) {}
    let(:payment_method_client_internal_ids) {}
    let(:localisation) {}
    let(:vehicle_type) {}
    let(:automated_ticket_accepted_time_units) {}
    let(:zipcodes) {}
    let(:automated_ticket_weekdays) {}
    let(:rate_option_client_internal_id) {}
    let(:license_plate) {}

    let(:service_vehicles_stub) do
      [
        {
          client_internal_id: 'a_fake_client_id',
          license_plate: 'a_fake_license_plate',
          vehicle_type: 'electric_motorcycle',
          vehicle_description: 'a_fake_name'
        }
      ]
    end
    let(:service_rate_options_75008_stub) do
      [
        { client_internal_id: '75008', name: 'Résident', type: 'RES', accepted_time_units: ['days'],
          free: false },
        { client_internal_id: '1085252721', name: 'shared rate option', type: 'CUSTOM',
          accepted_time_units: %w[minutes hours], free: true }
      ]
    end
    let(:service_rate_options_75017_stub) do
      [
        { client_internal_id: '75017', name: 'Résident', type: 'RES', accepted_time_units: ['days'],
          free: false },
        { client_internal_id: '1085252721', name: 'shared rate option', type: 'CUSTOM',
          accepted_time_units: %w[minutes hours], free: true }
      ]
    end
    let(:service_rate_options_75019_stub) do
      [
        { client_internal_id: '75019', name: 'Résident', type: 'RES', accepted_time_units: ['days'],
          free: false },
        { client_internal_id: '1085252721', name: 'shared rate option', type: 'CUSTOM',
          accepted_time_units: %w[minutes hours], free: true }
      ]
    end
    let(:service_payment_methods_stub) do
      [
       { client_internal_id: 'fake-payment-methof-id-9654e1084eb1', anonymised_card_number: '6156',
         payment_card_type: 'visa' }
        ]
    end
    before do
      allow(automated_ticket).to receive(:service).and_return(service)
      allow(service).to receive(:vehicles).and_return(service_vehicles_stub)
      allow(service).to receive(:rate_options).with("75008", any_args).and_return(service_rate_options_75008_stub)
      allow(service).to receive(:rate_options).with("75017", any_args).and_return(service_rate_options_75017_stub)
      allow(service).to receive(:rate_options).with("75019", any_args).and_return(service_rate_options_75019_stub)
      allow(service).to receive(:payment_methods).and_return(service_payment_methods_stub)
    end

    describe 'when there is only one service available' do
      it 'automatically set the service to this service' do
        expect { subject }.to change(automated_ticket, :service_id).from(nil).to(service.id)
      end
    end
    describe 'when there is only one vehicle' do
      let(:automated_ticket_service) { service }
      it 'automatically set the license_plate, vehicle_type and vehicle_description' do
        subject
        reloaded_automated_ticket = automated_ticket.reload
        expect(reloaded_automated_ticket.license_plate).to eq('a_fake_license_plate')
        expect(reloaded_automated_ticket.vehicle_type).to eq('electric_motorcycle')
        expect(reloaded_automated_ticket.vehicle_description).to eq('a_fake_name')
      end
    end
    describe 'when there is only one rate_options_shared_between_zipcodes' do
      let(:automated_ticket_service) { service }
      let(:localisation) { 'paris' }
      let(:license_plate) {'a_fake_license_plate'}
      let(:vehicle_type) {"electric_motorcycle"}
      let(:vehicle_description) {'a_fake_name'}
      let(:zipcodes){["75008", "75017", "75019"]}

      it 'automatically set the license_plate, vehicle_type and vehicle_description' do
        subject
        reloaded_automated_ticket = automated_ticket.reload
        expect(reloaded_automated_ticket.rate_option_client_internal_id).to eq('1085252721')
        expect(reloaded_automated_ticket.accepted_time_units).to eq(%w[minutes hours])
        expect(reloaded_automated_ticket.free).to eq(true)
      end
    end

    describe 'when there is only one payment_method' do
      let(:automated_ticket_service) { service }
      let(:localisation) { 'paris' }
      let(:license_plate) {'a_fake_license_plate'}
      let(:vehicle_type) {"electric_motorcycle"}
      let(:vehicle_description) {'a_fake_name'}
      let(:zipcodes){["75008", "75017", "75019"]}
      let(:rate_option_client_internal_id){'1085252721'}
      let(:accepted_time_units){%w[minutes hours]}
      let(:automated_ticket_free){false}

      it 'automatically set the license_plate, vehicle_type and vehicle_description' do
        subject
        reloaded_automated_ticket = automated_ticket.reload
        expect(reloaded_automated_ticket.payment_method_client_internal_ids).to eq(['fake-payment-methof-id-9654e1084eb1'])
      end
    end
  end
end
