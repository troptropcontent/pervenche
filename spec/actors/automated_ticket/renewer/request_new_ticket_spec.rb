# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'

RSpec.describe AutomatedTicket::Renewer::RequestNewTicket, type: :actor do
  include_context 'a user with a service with an automated ticket'
  subject {described_class.call(automated_ticket:, payment_method_id:, time_unit:, quantity:)}
  let(:payment_method_id) {'AFakePaymentMethodId'}
  let(:time_unit) {'days'}
  let(:quantity) {1}
  describe '.call' do
    it "requests a new ticket and saves the request in the database" do
      expect(automated_ticket).to receive(:renew!).with(
        quantity: , 
        time_unit: , 
        payment_method_client_internal_id: payment_method_id
      )
      ticket_request_count = TicketRequest.count
      subject  
      last_ticket_request_saved = TicketRequest.last
      expect(TicketRequest.count).to eq(ticket_request_count + 1)
      expect(last_ticket_request_saved.automated_ticket_id).to eq(automated_ticket.id)
      expect(last_ticket_request_saved.payment_method_client_internal_id).to eq('AFakePaymentMethodId')
      expect(last_ticket_request_saved.time_unit).to eq('days')
      expect(last_ticket_request_saved.quantity).to eq(1)
      expect(last_ticket_request_saved.requested_on).to be_within(0.1).of(Time.now)
    end
  end
end



