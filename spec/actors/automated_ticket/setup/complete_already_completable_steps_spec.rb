# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
require 'support/shared_context/service_stubs'

RSpec.describe AutomatedTicket::Setup::CompleteAlreadyCompletableSteps, type: :actor do
  subject { described_class.call(automated_ticket:) }
  include_context 'a stubed service'

  describe '.call' do
    include_context 'a user with a service with an automated ticket'

    describe 'when there is only one service available' do
      include_context 'a user with a service with an automated ticket'
      it 'automatically set the service to this service' do
        expect { subject }.to change(automated_ticket, :service_id).from(nil).to(service.id)
      end
    end
    describe 'when there is only one vehicle' do
      include_context 'a user with a service with an automated ticket', :localisation

      it 'automatically set the license_plate, vehicle_type and vehicle_description' do
        subject
        reloaded_automated_ticket = automated_ticket.reload
        expect(reloaded_automated_ticket.license_plate).to eq('CL123UU')
        expect(reloaded_automated_ticket.vehicle_type).to eq('electric_motorcycle')
        expect(reloaded_automated_ticket.vehicle_description).to eq('a_fake_name')
      end
    end
    describe 'when there is only one rate_options_shared_between_zipcodes' do
      include_context 'a user with a service with an automated ticket', :zipcodes
      it 'automatically set the license_plate, vehicle_type and vehicle_description' do
        subject
        reloaded_automated_ticket = automated_ticket.reload
        expect(reloaded_automated_ticket.rate_option_client_internal_id).to eq('1085252721')
        expect(reloaded_automated_ticket.accepted_time_units).to eq(%w[minutes hours])
        expect(reloaded_automated_ticket.free).to eq(true)
      end
    end
    describe 'when the rate option is free' do
      include_context 'a user with a service with an automated ticket', :rate_option
      let(:automated_ticket_free) { true }
      it 'automatically set the weekdays to every day' do
        subject
        reloaded_automated_ticket = automated_ticket.reload
        expect(reloaded_automated_ticket.weekdays).to eq([0, 1, 2, 3, 4, 5, 6])
      end
    end

    describe 'when there is only one payment_method' do
      include_context 'a user with a service with an automated ticket', :weekdays

      it 'automatically set the license_plate, vehicle_type and vehicle_description' do
        subject
        reloaded_automated_ticket = automated_ticket.reload
        expect(reloaded_automated_ticket.payment_method_client_internal_ids).to eq(['fake-payment-methof-id-9654e1084eb1'])
      end
    end
  end
end
