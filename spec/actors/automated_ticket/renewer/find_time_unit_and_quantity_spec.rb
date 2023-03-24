# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'

RSpec.describe AutomatedTicket::Renewer::FindTimeUnitAndQuantity, type: :actor do
  include_context 'a user with a service with an automated ticket'
  subject { described_class.call(automated_ticket:) }

  describe '.call' do
    context 'when automated_ticket.accepted_time_units includes days' do
      it 'assigns actor.time_unit to days and actor.quantity to 1' do
        expect(subject.time_unit).to eq('days')
        expect(subject.quantity).to eq(1)
      end
    end
    context 'when automated_ticket.accepted_time_units does not include days' do
      let(:automated_ticket_accepted_time_units) { ['hours'] }
      it 'assigns actor.time_unit to hours and actor.quantity to 1' do
        expect(subject.time_unit).to eq('hours')
        expect(subject.quantity).to eq(1)
      end
    end
  end
end
