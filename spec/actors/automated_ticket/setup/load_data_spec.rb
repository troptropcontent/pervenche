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
        FactoryBot.create(:automated_ticket, :with_localisation, user:, service:,
                                                                 setup_step: :localisation)
      end
      let(:user) { FactoryBot.create(:user) }
      let(:service) do
        service = FactoryBot.build(:service, user_id: user.id, chargebee_customer_id: 'kjhghkjhkjghjgqisd')
        service.save(validate: false)
        service
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
          let(:expected_data) do
            {
              charge_bee_subscription_id: 'BTM8jcTflrfneOn0',
              charge_bee_item_price_external_name: 'Abonnement mensuel scooter électrique',
              charge_bee_item_price_price: Money.new(500, 'EUR'),
              charge_bee_item_price_period: 'month',
              charge_bee_item_price_trial_period: 15,
              charge_bee_item_price_trial_period_unit: 'day'
            }
          end
          before do
            charge_bee_subscription_stub = cat = OpenStruct.new(subscription: OpenStruct.new(id: 'BTM8jcTflrfneOn0'))
            charge_bee_price_item_stub = OpenStruct.new(item_price: OpenStruct.new(
              external_name: 'Abonnement mensuel scooter électrique',
              price: 500,
              currency_code: 'EUR',
              period_unit: 'month',
              trial_period: 15,
              trial_period_unit: 'day'
            ))
            allow(ChargeBee::Subscription).to receive(:create_with_items).and_return(charge_bee_subscription_stub)
            allow(ChargeBee::ItemPrice).to receive(:retrieve).and_return(charge_bee_price_item_stub)
          end

          it 'loads the correct data', :vcr do
            output_data = subject.data
            expect(output_data).to eq(expected_data)
          end
        end
      end
    end
  end
end
