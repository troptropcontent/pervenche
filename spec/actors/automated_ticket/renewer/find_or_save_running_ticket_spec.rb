# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
RSpec.describe AutomatedTicket::Renewer::FindOrSaveRunningTicket, type: :actor do
  include_context 'a user with a service with an automated ticket'
  let(:zipcode) { '75018' }
  subject { described_class.call(automated_ticket:, zipcode:) }
  describe '.call' do
    context 'when a running ticket exists in the database' do
      let!(:running_ticket_in_database) do
        FactoryBot.create(:ticket, automated_ticket:, zipcode:, ends_on: Time.current + 2.hours)
      end
      it 'assigns actor.running_ticket with this ticket' do
        expect(subject.running_ticket).to eq(running_ticket_in_database)
      end
    end
    context 'when no running ticket is found in the database' do
      let!(:running_ticket_in_client) {nil}
      before do
        allow(automated_ticket).to(
          receive(:running_ticket_in_client_for).with(zipcode:)
            .and_return(running_ticket_in_client)
        )
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
        it 'saves the running ticket in the database and assigns actor.running_ticket with this ticket' do
          ticket_count = Ticket.count
          actor_running_ticket = subject.running_ticket
          expect(actor_running_ticket.license_plate).to eq('a fake license plate')
          expect(actor_running_ticket.starts_on).to be_within(0.01).of(running_ticket_in_client[:starts_on])
          expect(actor_running_ticket.ends_on).to be_within(0.01).of(running_ticket_in_client[:ends_on])
          expect(actor_running_ticket.cost_cents).to eq(100)
          expect(actor_running_ticket.automated_ticket).to eq(automated_ticket)
          expect(actor_running_ticket.zipcode).to eq(zipcode)
          expect(Ticket.count).to eq(ticket_count + 1)
        end
      end
      context 'when no ticket is found in the client' do
        it 'assigns actor.running_ticket with null' do
          expect(subject.running_ticket).to eq(nil)
        end
      end
    end
  end
end
