# typed: false
# frozen_string_literal: true

require 'rails_helper'

module ParkingTicket
  module Clients
    module PayByPhone
      RSpec.describe Client do
        subject { described_class.new(username, password) }
        let(:username) { 'a_fake_username' }
        let(:password) { 'a_fake_password' }
        let(:zipcode) { '75018' }
        let(:license_plate) { 'CL123UU' }
        describe '#instance_methods' do
          context '#valid_credentials?' do
            it 'check that credentials are valids' do
              VCR.use_cassette('auth') do
                expect(subject.valid_credentials?).to eq(true)
              end
            end
          end

          context '#vehicles' do
            it 'returns the vehicles' do
              VCR.use_cassette('pay_by_phone_vehicles') do
                expect(subject.vehicles).to match_json_schema('client/pay_by_phone/request/vehicles')
              end
            end
          end
          context '#rate_options' do
            it 'returns the rate options for a zipcode, an account_id and a vehicle' do
              VCR.use_cassette('pay_by_phone_rate_options') do
                result = subject.rate_options(zipcode, license_plate)
                expect(result).to match_json_schema('client/pay_by_phone/request/rate_options')
              end
            end
          end
          context '#running_tickets' do
            it 'returns the current tickets' do
              VCR.use_cassette('pay_by_phone_running_ticket') do
                expect(subject.running_tickets).to match_json_schema('client/pay_by_phone/request/tickets')
              end
            end
          end
          context '#payment_methods' do
            it 'returns the payment_methods registered for an account' do
              VCR.use_cassette('pay_by_phone_payment_methods') do
                expect(subject.payment_methods).to match_json_schema('client/pay_by_phone/request/payment_methods')
              end
            end
          end

          context '#quote' do
            let(:zipcode) { '75019' }
            let!(:rate_option_id) { '1085252721' }

            it 'returns the rate options for a zipcode, an account_id and a vehicle' do
              VCR.use_cassette('pay_by_phone_quote') do
                expect(subject.quote(rate_option_id, zipcode, license_plate, 1,
                                     'Days')).to match_json_schema('client/pay_by_phone/request/quote')
              end
            end
          end
        end
        describe '.class_methods' do
          it 'fetches the PayByPhoneApi'
        end
      end
    end
  end
end
