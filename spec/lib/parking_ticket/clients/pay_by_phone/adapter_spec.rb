# typed: false
# frozen_string_literal: true

require 'rails_helper'

module ParkingTicket
  module Clients
    module PayByPhone
      RSpec.describe Adapter do
        let(:username) { 'a_fake_username' }
        let(:password) { 'a_fake_password' }
        let(:license_plate) { 'CL123UU' }

        let(:zipcode) { '75018' }

        subject { described_class.new(username, password) }
        describe '#class_methods' do
          context '#vehicles', :vcr do
            let(:expected) do
              [ParkingTicket::Clients::Models::Vehicle.new(
                client_internal_id: 'dCqmcYtMBVHXeKKSPL6TZ3aGq3NoLCAgovAP-fJaAl2RBOeCgO62Q_M5Urz4Oakb1wmZ22TyN9MBtqzDUHBcyg',
                license_plate: 'CL123UU',
                vehicle_description: nil,
                vehicle_type: 'combustion_car'
              ),
               ParkingTicket::Clients::Models::Vehicle.new(
                 client_internal_id: 'v_cO-eR4UHbRCdX3MaO-aIrfFHQdaVLIMapxxLuFSe45RLZoAU9z1XdaiGTortXSqZH2k_9Rej97qB8Cdah2sQ',

                 license_plate: 'GF123XX',
                 vehicle_description: 'scoot de Tho',
                 vehicle_type: 'electric_motorcycle'
               ),
               ParkingTicket::Clients::Models::Vehicle.new(
                 client_internal_id: 'RArpPrn2JNLaZv7DKXg-IE1lmBuL09N5dzHKE1X28CcQNxVl9ixcU1_YaUVxro6A1eDuC7UtwYu39surE-coPg',

                 license_plate: 'ED123YY',
                 vehicle_description: nil,
                 vehicle_type: 'combustion_car'
               ),
               ParkingTicket::Clients::Models::Vehicle.new(
                 client_internal_id: 'UO1TTdQjA51k-gKgWZGZ6dWu66w_DeI1Ib5KkA1jahzyi6vpTAFXYBig1mjsgobirbsQiKYkGv_nb6LTWVls5A',

                 license_plate: 'FM123OO',
                 vehicle_description: 'van Cheyerre',
                 vehicle_type: 'combustion_car'
               )]
            end
            it 'returns the list of the vehicles' do
              VCR.use_cassette('pay_by_phone_vehicles') do
                expect(subject.vehicles).to eq(expected)
              end
            end
          end
          context '#rate_options' do
            let(:expected) do
              [
                ParkingTicket::Clients::Models::RateOption.new(
                  accepted_time_units: %w[minutes hours],
                  client_internal_id: '1085252721',
                  name: 'Voiture - Visiteur - 75012-75020',
                  type: 'CUSTOM'
                )
              ]
            end
            it 'returns the list of the rate options available' do
              VCR.use_cassette('pay_by_phone_rate_options') do
                expect(subject.rate_options(zipcode, license_plate)).to eq(expected)
              end
            end
          end

          context '#running_ticket(license_plate, zipcode)' do
            let(:expected) do
              ParkingTicket::Clients::Models::Ticket.new(
                client: 'PayByPhone',
                client_internal_id: '0b740a3a-e234-4a68-9f80-444221de4e83',
                cost: 1.5,
                ends_on: DateTime.parse('11 Apr 2023 17:16:00 +0000'),
                license_plate: 'CL123UU',
                starts_on: DateTime.parse('08 Apr 2023 17:16:13 +0000')
              )
            end
            it 'returns the running ticket' do
              VCR.use_cassette('pay_by_phone_running_ticket') do
                expect(subject.running_ticket(license_plate, zipcode)).to eq(expected)
              end
            end
          end

          context '#payment_methods' do
            let(:expected) do
              [ParkingTicket::Clients::Models::PaymentMethod.new(anonymised_card_number: '2021', client_internal_id: '2c19093a-a257-4011-a0a6-df9d1b62542f', payment_card_type: 'master_card'),
               ParkingTicket::Clients::Models::PaymentMethod.new(anonymised_card_number: '2358',
                                                                 client_internal_id: '6bb6073a-d81e-46ad-9a33-54337c1ddf82',  payment_card_type: 'visa'),
               ParkingTicket::Clients::Models::PaymentMethod.new(anonymised_card_number: '4436',
                                                                 client_internal_id: 'fb20073a-e4d5-40da-b6d2-d3e21651a4c4',  payment_card_type: 'visa'),
               ParkingTicket::Clients::Models::PaymentMethod.new(anonymised_card_number: '9321',
                                                                 client_internal_id: '4f67063a-c6f7-4f01-916b-84659dd13bdc',  payment_card_type: 'master_card'),
               ParkingTicket::Clients::Models::PaymentMethod.new(anonymised_card_number: '6750',
                                                                 client_internal_id: 'dfdc053a-5592-4d2e-9dc3-3b83d0567714',  payment_card_type: 'master_card'),
               ParkingTicket::Clients::Models::PaymentMethod.new(anonymised_card_number: '6156',
                                                                 client_internal_id: 'd5a8053a-81df-4ee2-a4d1-9654e1084eb1',  payment_card_type: 'visa')]
            end
            it 'returns the payment method registered for the account' do
              VCR.use_cassette('pay_by_phone_payment_methods') do
                expect(subject.payment_methods).to eq(expected)
              end
            end
          end

          context '#quote(rate_option_id, zipcode, license_plate, quantity, time_unit)' do
            it 'returns a quote correctly' do
              VCR.use_cassette('pay_by_phone_quote') do
                expect(subject.quote('1085252721', '75019', 'CL123UU', 1, 'days')).to eq(
                  ParkingTicket::Clients::Models::Quote.new(
                    client_internal_id: 'e3f527e9-58ea-49d1-a917-ff6880f1017f',
                    starts_on: DateTime.parse('11 Apr 2023 16:05:19 +0000'),
                    ends_on: DateTime.parse('12 Apr 2023 11:05:19 +0000'),
                    cost: 50.0
                  )
                )
              end
            end
          end

          context '#new_ticket(license_plate, zipcode, rate_option_id, quantity, time_unit, payment_method_id:)' do
            let(:rate_option_id) { 'a_fake_rate_option_id' }
            let(:payment_method_id) { 'a_fake_rate_option_id' }
            it 'request a new ticket', :vcr do
              stubed_client = ParkingTicket::Clients::PayByPhone::Client.new('fake_ser_name', 'fake_password')
              allow(ParkingTicket::Clients::PayByPhone::Adapter).to receive(:valid_credentials?).and_return(true)
              allow(stubed_client).to receive(:running_tickets).and_return({})
              allow(stubed_client).to receive(:payment_methods).and_return({ 'items' => [{ 'id' => 'fake_payment_method_id', 'maskedCardNumber' => '2021',
                                                                                           'paymentCardType' => 'Days' }] })
              allow(stubed_client).to receive(:quote).and_return({ 'quoteId' => 'faked_quote_id', 'parkingStartTime' => '2023-04-03T17:11:12+00:00',
                                                                   'parkingExpiryTime' => '2023-05-03T17:11:12+00:00', 'totalCost' => { 'amount' => '2' } })
              allow(ParkingTicket::Clients::PayByPhone::Client).to receive(:new).and_return(stubed_client)
              expect(stubed_client).to receive(:new_ticket).with(
                zipcode: '75018',
                license_plate: 'license_plate',
                rate_option_client_internal_id: 'a_fake_rate_option_id',
                quantity: 1,
                time_unit: 'Days',
                quote_client_internal_id: 'faked_quote_id',
                starts_on: DateTime.parse('2023-04-03T17:11:12+00:00'),
                payment_method_id: 'fake_payment_method_id'
              )
              subject.new_ticket(license_plate: 'license_plate', zipcode: '75018', rate_option_client_internal_id: 'a_fake_rate_option_id',
                                 quantity: 1, time_unit: 'days', payment_method_id: 'fake_payment_method_id')
            end
          end
        end
      end
    end
  end
end
