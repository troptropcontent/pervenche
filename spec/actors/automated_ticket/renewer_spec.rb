# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Renewer, type: :actor do
  subject { described_class.call(automated_ticket_id: automated_ticket.id, zipcode: '75016', last_request_on:) }
  let(:last_request_on) { nil }
  let(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes:, weekdays:, free:, accepted_time_units:)
  end
  let(:free) { false }
  let(:accepted_time_units) { ['days'] }
  let(:weekdays) { [Date.today.wday] }
  let(:zipcodes) { %w[75018 75017 75016] }
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end
  before do
    allow(AutomatedTicket).to receive(:find).with(automated_ticket.id).and_return(automated_ticket)
  end

  describe '.call' do
    shared_examples 'it does not request a new ticket' do
      it 'does not request a new ticket' do
        expect(automated_ticket).not_to receive(:renew!)
        expect { subject }.not_to change(TicketRequest, :count)
      end
    end
    context 'when a running ticket is found in the database' do
      let!(:running_ticket_in_database) do
        FactoryBot.create(:ticket, automated_ticket:, zipcode: '75016', ends_on: 2.hours.from_now)
      end
      it_behaves_like 'it does not request a new ticket'
    end
    context 'when a running ticket is not found in the database' do
      context 'when a running_ticket is found in the client' do
        before do
          allow(automated_ticket).to receive(:running_ticket_in_client_for).with({ zipcode: '75016' }).and_return(running_ticket_in_client)
        end
        let(:running_ticket_in_client) {}
        context 'when a running ticket is found at the client' do
          let(:running_ticket_in_client) do
            ParkingTicket::Clients::Models::Ticket.new(
              client_internal_id: '34ae093a-37f4-4326-bdbf-7965c82b378a',
              starts_on: (Time.now - 1.day).to_datetime,
              ends_on: (Time.now + 1.day).to_datetime,
              license_plate: 'a fake license plate',
              cost: 1.0,
              client: 'PayByPhone'
            )
          end

          it_behaves_like 'it does not request a new ticket'
          it 'creates a new ticket in the database' do
            expect { subject }.to change(Ticket, :count).by(1)
          end
        end
        context 'when a running ticket is not found at the client' do
          context 'when automated ticket should not be renewed today' do
            let(:weekdays) { [Date.today.tomorrow.wday] }
            it_behaves_like 'it does not request a new ticket'
          end
          context 'when automated_ticket should be renewed today' do
            let(:expected_qantity) { 1 }
            let(:expected_time_unit) { 'days' }
            let(:expected_payment_method_client_internal_id) { 'rytrtt88ppezoezpeop' }
            shared_examples 'it requests a new ticket' do
              it 'it requests a new ticket' do
                expect(automated_ticket).to receive(:renew!).with(
                  zipcode: '75016',
                  quantity: expected_qantity,
                  time_unit: expected_time_unit,
                  payment_method_client_internal_id: expected_payment_method_client_internal_id
                )
                expect { subject }.to change(TicketRequest, :count).by(1)
                expect(subject.ticket_request.automated_ticket_id).to eq(automated_ticket.id)
                expect(subject.ticket_request.payment_method_client_internal_id).to eq(expected_payment_method_client_internal_id)
                expect(subject.ticket_request.time_unit).to eq(expected_time_unit)
                expect(subject.ticket_request.quantity).to eq(expected_qantity)
                expect(subject.ticket_request.requested_on).to be_within(1).of(Time.now)
                expect(subject.ticket_request.zipcode).to eq('75016')
              end
            end
            context 'when automated_ticket is free' do
              let(:free) { true }
              let(:expected_payment_method_client_internal_id) { nil }
              it_behaves_like 'it requests a new ticket'
            end
            context 'when automated_ticket.payment_method_client_internal_id is not set to free' do
              it_behaves_like 'it requests a new ticket'
            end
            context 'when automated_ticket.accepted_time_units contains days' do
              let(:expected_time_unit) { 'days' }
              it_behaves_like 'it requests a new ticket'
            end
            context 'when automated_ticket.accepted_time_units does not contain days' do
              let(:accepted_time_units) { ['something_else'] }
              let(:expected_time_unit) { 'hours' }
              it_behaves_like 'it requests a new ticket'
            end

            context 'when the ticket have been requested less than 5 minutes ago' do
              let(:last_request_on) { 4.minutes.ago }
              it_behaves_like 'it does not request a new ticket'
            end
          end
        end
      end
    end
  end
end
