# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
require 'support/shared_context/service_stubs'

RSpec.describe AutomatedTicket::Setup::LoadData, type: :actor do
  include Rails.application.routes.url_helpers
  subject { described_class.call(automated_ticket:, step:, params:) }
  let(:step) { :service }
  let(:params) do
    {}
  end
  describe '.call' do
    describe 'base_data' do
      let(:automated_ticket) do
        automated_ticket = FactoryBot.create(:automated_ticket, :with_kind, user:, service:, setup_step: :kind)
      end
      let(:user) { FactoryBot.create(:user) }
      let(:service) do
        service = FactoryBot.build(:service, user_id: user.id)
        service.save(validate: false)
        service
      end
      describe 'previous_step' do
        context 'when there is a previous_step param' do
          context 'wich is valid' do
            let(:params) do
              { previous_step: 'vehicle' }
            end
            let(:step) { :kind }
            let(:expected_data) do
              { previous_step_path: "/automated_tickets/#{automated_ticket.id}/setup/vehicle" }
            end
            it 'loads the correct path' do
              expect(subject.data).to eq(expected_data)
            end
          end
          context 'wich is not valid' do
            let(:params) do
              { previous_step: 'localisation' }
            end
            let(:step) { :kind }
            let(:expected_data) do
              {}
            end
            it 'does not load a path' do
              expect(subject.data).to eq(expected_data)
            end
          end
        end
      end
    end
    describe 'step' do
      include_context 'a user with a service with an automated ticket', :payment_methods
      include_context 'a stubed service'
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
            ParkingTicket::Clients::Models::Vehicle.new(
              client_internal_id: 'a_fake_client_id',
              license_plate: 'CL123UU',
              vehicle_description: 'a_fake_name',
              vehicle_type: 'electric_motorcycle'
            )
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
            ParkingTicket::Clients::Models::RateOption.new(
              accepted_time_units: %w[minutes hours],
              client_internal_id: '1085252721',
              free: true,
              name: 'shared rate option',
              type: 'CUSTOM'
            )
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
            ParkingTicket::Clients::Models::PaymentMethod.new(
              anonymised_card_number: '6156',
              client_internal_id: 'fake-payment-methof-id-9654e1084eb1',
              payment_card_type: 'visa'
            )
          ] }
        end
        it 'loads the correct data' do
          expect(subject.data).to eq(expected_data)
        end
      end

      context 'zipcodes' do
        let(:params) do
          ActionController::Parameters.new(
            {
              localisation: 'paris'
            }
          )
        end
        let(:step) { :zipcodes }
        let(:expected_data) do
          { localisation: 'paris' }
        end
        it 'loads the correct data' do
          expect(subject.data).to eq(expected_data)
        end
      end

      context 'subscription' do
        let(:step) { :subscription }
        context 'when the payment have not been processed' do
          let(:params) do
            ActionController::Parameters.new(
              {}
            )
          end
          let(:expected_data) do
            {
              plan_id: 'combustion_car',
              hosted_page_data: '{"values":{"id":"oXZvOrUdHBk7WGakcd5upSFwPivz1BcdtV","type":"checkout_new","url":"https://pervenche-test.chargebee.com/pages/v3/oXZvOrUdHBk7WGakcd5upSFwPivz1BcdtV/","state":"created","embed":false,"created_at":1682670453,"expires_at":1682681253,"object":"hosted_page","updated_at":1682670453,"resource_version":1682670453426},"sub_types":{},"dependant_types":{},"id":"oXZvOrUdHBk7WGakcd5upSFwPivz1BcdtV","type":"checkout_new","url":"https://pervenche-test.chargebee.com/pages/v3/oXZvOrUdHBk7WGakcd5upSFwPivz1BcdtV/","state":"created","embed":false,"created_at":1682670453,"expires_at":1682681253,"object":"hosted_page","updated_at":1682670453,"resource_version":1682670453426}'
            }
          end
          it 'loads the correct data' do
            VCR.use_cassette('chargebee_checkout_new_for_items') do
              expect(subject.data).to eq(expected_data)
            end
          end
        end
        context 'when the payment have been processed' do
          let(:params) do
            ActionController::Parameters.new(
              {
                id: 'a_chargebee_customer_id'
              }
            )
          end
        end
      end
    end
  end
end
