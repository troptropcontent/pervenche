# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
RSpec.describe AutomatedTicket::Renewer::FindPaymentMethod, type: :actor do
  include_context 'a user with a service with an automated ticket'
  subject { described_class.call(automated_ticket:) }
  describe '.call' do
    context 'when the automated_ticket is free' do
      let(:automated_ticket_free) { true }
      it 'should assigns actor.payment_method_id to nil' do
        expect(subject.payment_method_id).to eq(nil)
      end
    end
    context 'when the automated_ticketis not free' do
      let(:automated_ticket_free) { false }
      let(:payment_method_client_internal_ids) { ['the_first_payment_id', 'the_second_payment_method_id'] }
      it 'should assigns actor.payment_method_id to the first payment_method_client_internal_id' do
        expect(subject.payment_method_id).to eq('the_first_payment_id')
      end
    end
  end
end
