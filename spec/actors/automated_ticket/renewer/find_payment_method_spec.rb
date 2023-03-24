# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
RSpec.describe AutomatedTicket::Renewer::FindPaymentMethod, type: :actor do
  include_context 'a user with a service with an automated ticket'
  subject { described_class.call(automated_ticket:) }
  describe '.call' do
    context 'when the automated_ticket.payment_method_client_internal_id is free' do
      let(:automated_ticket_payment_method_client_internal_id) { 'free' }
      it 'should assigns actor.payment_method_id to nil' do
        expect(subject.payment_method_id).to eq(nil)
      end
    end
    context 'when the automated_ticket.payment_method_client_internal_id is not free' do
      it 'should assigns actor.payment_method_id to payment_method_client_internal_id' do
        expect(subject.payment_method_id).to eq(automated_ticket.payment_method_client_internal_id)
      end
    end
  end
end
