# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AutomatedTicket::Renewer::FindOrSaveRunningTicket, type: :actor do
  subject { described_class.call(automated_ticket:, zipcode:) }
  let(:zipcode) { '75018' }
  let(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes:, weekdays:, free:, accepted_time_units:,
                                                  payment_method_client_internal_ids:)
  end
  let(:free) { false }
  let(:payment_method_client_internal_ids) { ['azertyuiop'] }
  let(:accepted_time_units) { ['days'] }
  let(:weekdays) { [Date.today.wday] }
  let(:zipcodes) { %w[75018 75017 75016] }
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end

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
      let!(:running_ticket_in_client) { nil }
      before do
        allow(automated_ticket).to(
          receive(:running_ticket_in_client_for).with(zipcode:)
            .and_return(running_ticket_in_client)
        )
      end
      context 'when a running ticket is found at the client' do
        let(:running_ticket_in_client) do
          ParkingTicket::Clients::Models::Ticket.new(
            client_internal_id: '34ae093a-37f4-4326-bdbf-7965c82b378a',
            starts_on: (Time.now - 1.days).to_datetime,
            ends_on: (Time.now + 1.days).to_datetime,
            license_plate: 'a fake license plate',
            cost: 1.0,
            client: 'PayByPhone'
          )
        end
        it 'saves the running ticket in the database and assigns actor.running_ticket with this ticket' do
          ticket_count = Ticket.count
          actor_running_ticket = subject.running_ticket
          expect(actor_running_ticket.license_plate).to eq('a fake license plate')
          expect(actor_running_ticket.starts_on).to be_within(0.01).of(running_ticket_in_client.starts_on)
          expect(actor_running_ticket.ends_on).to be_within(0.01).of(running_ticket_in_client.ends_on)
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
