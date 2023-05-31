# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Renewer::RequestNewTicket, type: :actor do
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

  subject { described_class.call(zipcode:, automated_ticket:, payment_method_id:, time_unit:, quantity:) }
  let(:zipcode) { '75018' }
  let(:payment_method_id) { 'azertyuiop' }
  let(:time_unit) { 'days' }
  let(:quantity) { 1 }
  describe '.call' do
    it 'requests a new ticket and saves the request in the database' do
      expect(automated_ticket).to receive(:renew!).with(
        zipcode:,
        quantity:,
        time_unit:,
        payment_method_client_internal_id: payment_method_id
      )
      ticket_request_count = TicketRequest.count
      subject
      expect(TicketRequest.count).to eq(ticket_request_count + 1)
      expect(subject.ticket_request.automated_ticket_id).to eq(automated_ticket.id)
      expect(subject.ticket_request.zipcode).to eq(zipcode)
      expect(subject.ticket_request.payment_method_client_internal_id).to eq('azertyuiop')
      expect(subject.ticket_request.time_unit).to eq('days')
      expect(subject.ticket_request.quantity).to eq(1)
      expect(subject.ticket_request.requested_on).to be_within(1).of(Time.now)
    end
  end
end
