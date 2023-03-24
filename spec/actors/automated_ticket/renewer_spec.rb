# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'

RSpec.describe AutomatedTicket::Renewer, type: :actor do
  include_context 'a user with a service with an automated ticket'
  subject { described_class.call(automated_ticket:) }
  describe '.call' do
    shared_examples 'it does not request a new ticket' do
      it 'does not request a new ticket' do
        expect(automated_ticket).not_to receive(:renew!)
        expect { subject }.not_to change(TicketRequest, :count)
      end
    end
    context 'when a running ticket is found in the database' do
      let!(:running_ticket_in_database) do
        FactoryBot.create(:ticket, automated_ticket:, ends_on: Time.current + 2.hours)
      end
      it_behaves_like 'it does not request a new ticket'
    end
    context 'when a running ticket is not found in the database' do
      context 'when a running_ticket is found in the client' do
        let!(:running_ticket_in_client) {}
        before do
          allow(automated_ticket).to receive(:running_ticket_in_client).and_return(running_ticket_in_client)
        end
        context 'when a running ticket is found at the client' do
          let(:running_ticket_in_client) do
            { client_internal_id: '34ae093a-37f4-4326-bdbf-7965c82b378a',
              starts_on: Time.now - 1.days,
              ends_on: Time.now + 1.days,
              license_plate: 'a fake license plate',
              cost: 1,
              client: 'PayByPhone' }
          end

          it_behaves_like 'it does not request a new ticket'
          it 'creates a new ticket in the database' do
            expect { subject }.to change(Ticket, :count).by(1)
          end
        end
        context 'when a running ticket is not found at the client' do
          context 'when automated ticket should not be renewed today' do
            let(:automated_ticket_weekdays) { [Date.today.tomorrow.wday] }
            it_behaves_like 'it does not request a new ticket'
          end
          context 'when automated_ticket should be renewed today' do
            let(:automated_ticket_weekdays) { [Date.today.wday] }
            let(:expected_qantity) { 1 }
            let(:expected_time_unit) { 'days' }
            let(:expected_payment_method_client_internal_id) { 'AFakePaymentMethodId' }
            shared_examples 'it requests a new ticket' do
              it 'does not request a new ticket' do
                expect(automated_ticket).to receive(:renew!).with(
                  quantity: expected_qantity,
                  time_unit: expected_time_unit,
                  payment_method_client_internal_id: expected_payment_method_client_internal_id
                )
                expect { subject }.to change(TicketRequest, :count).by(1)
                expect(subject.ticket_request.automated_ticket_id).to eq(automated_ticket.id)
                expect(subject.ticket_request.payment_method_client_internal_id).to eq(expected_payment_method_client_internal_id)
                expect(subject.ticket_request.time_unit).to eq(expected_time_unit)
                expect(subject.ticket_request.quantity).to eq(expected_qantity)
                expect(subject.ticket_request.requested_on).to be_within(0.1).of(Time.now)
              end
            end
            context 'when automated_ticket.payment_method_client_internal_id is set to free' do
              let(:automated_ticket_payment_method_client_internal_id) { 'free' }
              let(:expected_payment_method_client_internal_id) { nil }
              it_behaves_like 'it requests a new ticket'
            end
            context 'when automated_ticket.payment_method_client_internal_id is not set to free' do
              let(:automated_ticket_payment_method_client_internal_id) { 'a_payment_id' }
              let(:expected_payment_method_client_internal_id) { 'a_payment_id' }
              it_behaves_like 'it requests a new ticket'
            end
            context 'when automated_ticket.accepted_time_units contains days' do
              let(:automated_ticket_accepted_time_units) { ['days'] }
              let(:expected_time_unit) { 'days' }
              it_behaves_like 'it requests a new ticket'
            end
            context 'when automated_ticket.accepted_time_units does not contain days' do
              let(:automated_ticket_accepted_time_units) { ['something_else'] }
              let(:expected_time_unit) { 'hours' }
              it_behaves_like 'it requests a new ticket'
            end
          end
        end
      end
    end
  end
end
