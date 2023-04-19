# typed: false
# frozen_string_literal: true

require 'rails_helper'
module ParkingTicket
  RSpec.describe Base do
    subject { described_class.new(adapter_name, username, password) }
    let(:adapter_name) { 'pay_by_phone' }
    let(:username) { 'username' }
    let(:password) { 'password' }
    let(:zipcode) { '75018' }
    let(:license_plate) { 'CL123UU' }
    let(:rate_option_id) { 'rate_option_id' }
    let(:quantity) { 1 }
    let(:time_unit) { 'days' }
    let(:payment_method_id) { nil }

    context 'pay_by_phone' do
      let(:stubed_client) { Clients::PayByPhone::Adapter.new(username, password) }
      before do
        allow(Clients::PayByPhone::Adapter).to receive(:valid_credentials?).with(username, password).and_return(true)
        allow(Clients::PayByPhone::Adapter).to receive(:new).and_return(stubed_client)
      end

      describe '#vehicles' do
        it 'calls the PayByPhone::Adapter#vehicles' do
          expect(stubed_client).to receive(:vehicles).and_return([])
          subject.vehicles
        end
      end

      describe '#rate_options' do
        it 'calls the PayByPhone::Adapter#rate_options' do
          expect(stubed_client).to receive(:rate_options).with('75018', 'CL123UU').and_return([])
          subject.rate_options(zipcode, license_plate)
        end
      end

      describe '#running_ticket' do
        it 'calls the PayByPhone::Adapter#running_ticket' do
          expect(stubed_client).to receive(:running_ticket).with('CL123UU', '75018')
          subject.running_ticket(license_plate, zipcode)
        end
      end

      describe '#payment_methods' do
        it 'calls the PayByPhone::Adapter#payment_methods' do
          expect(stubed_client).to receive(:payment_methods).and_return([])
          subject.payment_methods
        end
      end

      describe '#quote' do
        it 'calls the PayByPhone::Adapter#quote' do
          expect(stubed_client).to receive(:quote).with('rate_option_id', '75018', 'CL123UU', 1,
                                                        'days').and_return(ParkingTicket::Clients::Models::Quote.new(
                                                                             client_internal_id: '13a3556a-afeb-46a3-b82f-e94bab23c1c0',
                                                                             starts_on: DateTime.parse('2023-04-05T06:15:56Z'),
                                                                             ends_on: DateTime.parse('2023-04-05T18:00:00Z'),
                                                                             cost: 1.5
                                                                           ))
          subject.quote(rate_option_id, zipcode, license_plate, quantity, time_unit)
        end
      end

      describe '#new_ticket' do
        it 'calls the PayByPhone::Adapter and request new_ticket' do
          expect(stubed_client).to receive(:new_ticket).with(
            rate_option_client_internal_id: 'rate_option_id',
            zipcode: '75018',
            license_plate: 'CL123UU',
            quantity: 1,
            time_unit: 'days',
            payment_method_id: nil
          )
          subject.new_ticket(license_plate:, zipcode:,
                             rate_option_client_internal_id: rate_option_id, quantity:, time_unit:, payment_method_id: nil)
        end
      end
    end
    context 'easy_park' do
      let(:adapter_name) { 'easy_park' }
      it 'raises an error' do
        expect do
          subject
        end.to raise_error(ParkingTicket::Base::Error, 'EasyPark will be handled in the next major release')
      end
    end
    context 'other' do
      let(:adapter_name) { 'other' }
      it 'raises an error' do
        expect do
          subject
        end.to raise_error(ParkingTicket::Base::Error, 'Unhandled adapter : other')
      end
    end
  end
end
